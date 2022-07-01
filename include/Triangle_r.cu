#include "./Triangle_r.cuh"
//------------------------

template <typename T>
__device__ __host__ cuDFNsys::Triangle_r<T>::Triangle_r<T>(vec2_select_t<T> a, vec2_select_t<T> b, vec2_select_t<T> c, vec1_select_t<T> i)
{
    Coordinate[0] = a;
    Coordinate[1] = b;
    Coordinate[2] = c;
    Tag = i;
};
template __device__ __host__ cuDFNsys::Triangle_r<double>::Triangle_r<double>(vec2_select_t<double> a, vec2_select_t<double> b, vec2_select_t<double> c, vec1_select_t<double> i);

template <typename T>
__device__ __host__ vec2_select_t<T> cuDFNsys::Triangle_r<T>::GetOneEnd(int i)
{
    if (i > 2)
        return Coordinate[2];

    return Coordinate[i];
};
template __device__ __host__ vec2_select_t<double> cuDFNsys::Triangle_r<double>::GetOneEnd(int i);
template __device__ __host__ vec2_select_t<float> cuDFNsys::Triangle_r<float>::GetOneEnd(int i);