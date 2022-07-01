#pragma once

#include <ctime>
#include <cuda.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <iostream>
#include <stdlib.h>
#include <string>
#include <thrust/device_vector.h>
#include <thrust/host_vector.h>
using namespace std;

template <typename T>
struct vec_selector
{
};

template <>
struct vec_selector<double>
{
    using vec3_type = double3;
    using vec2_type = double2;
    using vec1_type = double;
};

template <>
struct vec_selector<float>
{
    using vec3_type = float3;
    using vec2_type = float2;
    using vec1_type = float;
};

template <typename P>
using vec3_select_t = typename vec_selector<P>::vec3_type;

template <typename P>
using vec2_select_t = typename vec_selector<P>::vec2_type;

template <typename P>
using vec1_select_t = typename vec_selector<P>::vec1_type;

//------------------
//------------------
//------------------

namespace cuDFNsys
{
template <typename T>
struct Triangle_r
{
public:
    vec2_select_t<T> Coordinate[3];
    vec1_select_t<T> Tag;

public:
    __device__ __host__ Triangle_r()
    {
        vec2_select_t<T> Jl;
        Jl.x = 0;
        Jl.y = 0;

        Coordinate[0] = Jl, Coordinate[1] = Jl, Coordinate[2] = Jl;
        Tag = 0;
    };

    __device__ __host__ Triangle_r(vec2_select_t<T> a, vec2_select_t<T> b, vec2_select_t<T> c, vec1_select_t<T> i);

    __device__ __host__ vec2_select_t<T> GetOneEnd(int i);
};
}; // namespace cuDFNsys