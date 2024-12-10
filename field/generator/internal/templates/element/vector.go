package element

const Vector = `
import (
	"io"
	"encoding/binary"
	"strings"
	"bytes"
	"runtime"
	"unsafe"
	"sync"
	"sync/atomic"
	"fmt"
)

// Vector represents a slice of {{.ElementName}}.
// 
// It implements the following interfaces:
//	- Stringer
//	- io.WriterTo
//	- io.ReaderFrom
//	- encoding.BinaryMarshaler
//	- encoding.BinaryUnmarshaler
//	- sort.Interface
type Vector []{{.ElementName}}

// MarshalBinary implements encoding.BinaryMarshaler
func (vector *Vector) MarshalBinary() (data []byte, err error) {
	var buf bytes.Buffer

	if _, err = vector.WriteTo(&buf); err != nil {
		return
	}
	return buf.Bytes(), nil
}


// UnmarshalBinary implements encoding.BinaryUnmarshaler
func (vector *Vector) UnmarshalBinary(data []byte) error {
	r := bytes.NewReader(data)
	_, err := vector.ReadFrom(r)
	return err
}

// WriteTo implements io.WriterTo and writes a vector of big endian encoded {{.ElementName}}.
// Length of the vector is encoded as a uint32 on the first 4 bytes.
func (vector *Vector) WriteTo(w io.Writer) (int64, error) {
    // encode slice length
    if err := binary.Write(w, binary.BigEndian, uint32(len(*vector))); err != nil {
        return 0, err 
    }

	n := int64(4)

	var buf [Bytes]byte 
	for i := 0; i < len(*vector); i++ {
		BigEndian.PutElement(&buf, (*vector)[i])
		m, err := w.Write(buf[:])
		n += int64(m)
		if err != nil {
			return n, err 
		} 
	}
	return n, nil
}

// AsyncReadFrom reads a vector of big endian encoded {{.ElementName}}.
// Length of the vector must be encoded as a uint32 on the first 4 bytes.
// It consumes the needed bytes from the reader and returns the number of bytes read and an error if any.
// It also returns a channel that will be closed when the validation is done.
// The validation consist of checking that the elements are smaller than the modulus, and
// converting them to montgomery form.
func (vector *Vector) AsyncReadFrom(r io.Reader) (int64, error, chan error) {
	chErr := make(chan error, 1)
	var buf [Bytes]byte 
	if read, err := io.ReadFull(r, buf[:4]); err != nil {
		close(chErr)
        return int64(read), err, chErr
    }
	sliceLen := binary.BigEndian.Uint32(buf[:4])

    n := int64(4)
	(*vector) = make(Vector, sliceLen)
	if sliceLen == 0 {
		close(chErr)
		return n, nil, chErr
	}

	bSlice := unsafe.Slice((*byte)(unsafe.Pointer(&(*vector)[0])), sliceLen*Bytes)
	read, err := io.ReadFull(r, bSlice)
	n += int64(read)
	if err != nil {
		close(chErr)
		return n, err, chErr
	}


	go func() {
		var cptErrors uint64
		// process the elements in parallel
		execute(int(sliceLen), func(start, end int) {
			
			var z {{.ElementName}}
			for i:=start; i < end; i++ {
				// we have to set vector[i]
				bstart := i*Bytes
				bend := bstart + Bytes
				b := bSlice[bstart:bend]
				{{- range $i := reverse .NbWordsIndexesFull}}
					{{- $j := mul $i $.Word.ByteSize}}
					{{- $k := sub $.NbWords 1}}
					{{- $k := sub $k $i}}
					{{- $jj := add $j $.Word.ByteSize}}
					z[{{$k}}] = binary.BigEndian.{{$.Word.TypeUpper}}(b[{{$j}}:{{$jj}}])
				{{- end}}

				if !z.smallerThanModulus() {
					atomic.AddUint64(&cptErrors, 1)
					return
				}
				z.toMont()
				(*vector)[i] = z
			}
		})

		if cptErrors > 0 {
			chErr <- fmt.Errorf("async read: %d elements failed validation", cptErrors)
		}
		close(chErr)
	}()
	return n, nil, chErr
}

// ReadFrom implements io.ReaderFrom and reads a vector of big endian encoded {{.ElementName}}.
// Length of the vector must be encoded as a uint32 on the first 4 bytes.
func (vector *Vector) ReadFrom(r io.Reader) (int64, error) {

	var buf [Bytes]byte 
	if read, err := io.ReadFull(r, buf[:4]); err != nil {
        return int64(read), err 
    }
	sliceLen := binary.BigEndian.Uint32(buf[:4])

    n := int64(4)
	(*vector) = make(Vector, sliceLen)

    for i:=0; i < int(sliceLen); i++ {
        read, err := io.ReadFull(r, buf[:])
        n += int64(read)
        if err != nil {
            return n, err
        }
		(*vector)[i], err = BigEndian.Element(&buf)
		if err != nil {
			return n, err
		}
    }
	

    return n, nil 
}

// String implements fmt.Stringer interface
func (vector Vector) String() string {
    var sbb strings.Builder
    sbb.WriteByte('[')
    for i:=0; i < len(vector); i++ {
        sbb.WriteString(vector[i].String())
		if i != len(vector) - 1 {
			sbb.WriteByte(',')
		}
    }
    sbb.WriteByte(']')
    return sbb.String()
}

// Len is the number of elements in the collection.
func (vector Vector) Len() int {
	return len(vector)
}

// Less reports whether the element with
// index i should sort before the element with index j.
func (vector Vector) Less(i, j int) bool {
	return vector[i].Cmp(&vector[j]) == -1
}

// Swap swaps the elements with indexes i and j.
func (vector Vector) Swap(i, j int) {
	vector[i], vector[j] = vector[j], vector[i]
}


func addVecGeneric(res, a, b Vector) {
	if len(a) != len(b) || len(a) != len(res) {
		panic("vector.Add: vectors don't have the same length")
	}
	for i := 0; i < len(a); i++ {
		res[i].Add(&a[i], &b[i])
	}
}

func subVecGeneric(res, a, b Vector) {
	if len(a) != len(b) || len(a) != len(res) {
		panic("vector.Sub: vectors don't have the same length")
	}
	for i := 0; i < len(a); i++ {
		res[i].Sub(&a[i], &b[i])
	}
}

func scalarMulVecGeneric(res, a Vector, b *{{.ElementName}}) {
	if len(a) != len(res) {
		panic("vector.ScalarMul: vectors don't have the same length")
	}
	for i := 0; i < len(a); i++ {
		res[i].Mul(&a[i], b)
	}
}

func sumVecGeneric(res *{{.ElementName}}, a Vector) {
	for i := 0; i < len(a); i++ {
		res.Add(res, &a[i])
	}
}

func innerProductVecGeneric(res *{{.ElementName}},a, b Vector) {
	if len(a) != len(b) {
		panic("vector.InnerProduct: vectors don't have the same length")
	}
	var tmp {{.ElementName}}
	for i := 0; i < len(a); i++ {
		tmp.Mul(&a[i], &b[i])
		res.Add(res, &tmp)
	}
}

func mulVecGeneric(res, a, b Vector) {
	if len(a) != len(b) || len(a) != len(res) {
		panic("vector.Mul: vectors don't have the same length")
	}
	for i := 0; i < len(a); i++ {
		res[i].Mul(&a[i], &b[i])
	}
}

// TODO @gbotrel make a public package out of that.
// execute executes the work function in parallel.
// this is copy paste from internal/parallel/parallel.go
// as we don't want to generate code importing internal/ 
func execute(nbIterations int, work func(int, int), maxCpus ...int) {

	nbTasks := runtime.NumCPU()
	if len(maxCpus) == 1 {
		nbTasks = maxCpus[0]
		if nbTasks < 1 {
			nbTasks = 1
		} else if nbTasks > 512 {
			nbTasks = 512
		}
	}

	if nbTasks == 1 {
		// no go routines
		work(0, nbIterations)
		return
	}

	nbIterationsPerCpus := nbIterations / nbTasks

	// more CPUs than tasks: a CPU will work on exactly one iteration
	if nbIterationsPerCpus < 1 {
		nbIterationsPerCpus = 1
		nbTasks = nbIterations
	}

	var wg sync.WaitGroup

	extraTasks := nbIterations - (nbTasks * nbIterationsPerCpus)
	extraTasksOffset := 0

	for i := 0; i < nbTasks; i++ {
		wg.Add(1)
		_start := i*nbIterationsPerCpus + extraTasksOffset
		_end := _start + nbIterationsPerCpus
		if extraTasks > 0 {
			_end++
			extraTasks--
			extraTasksOffset++
		}
		go func() {
			work(_start, _end)
			wg.Done()
		}()
	}

	wg.Wait()
}


`
