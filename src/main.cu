#include "Triangle_r.cuh"

template <typename T>
__global__ void TestKernel(cuDFNsys::Triangle_r<T> *K, uint count)
{
    //printf("kernel\n");
    int i = threadIdx.x + blockIdx.x * blockDim.x;
    //printf("thread: %d\n", i);
    if (i > count - 1)
        return;

    vec2_select_t<T> KJ;
    KJ.x = 1000;
    KJ.y = 10000;

    K[i].Coordinate[0] = KJ;
    //printf("%f,, %f\n", K[i].Coordinate[0].x, K[i].Coordinate[0].y);
};
template __global__ void TestKernel(cuDFNsys::Triangle_r<double> *K, uint count);
template __global__ void TestKernel(cuDFNsys::Triangle_r<float> *K, uint count);

int main()
{
    using data_type_ = double;
    int dev = 0;
    cudaSetDevice(dev);

    vec2_select_t<data_type_> HT[3];
    HT[0].x = 1, HT[0].y = 2;
    HT[1].x = 3, HT[1].y = 8;
    HT[2].x = 7, HT[2].y = 4;

    cuDFNsys::Triangle_r<data_type_> HS;

    cuDFNsys::Triangle_r<data_type_> HH(HT[0], HT[1], HT[2], 1.0);

    cout << "First node/end of the triangle: " << HH.Coordinate[0].x << ", " << HH.Coordinate[0].y << endl;
    cout << "Tag: " << HH.Tag << endl;

    int NodeNO = 1;
    vec2_select_t<data_type_> JK = HH.GetOneEnd(NodeNO);
    cout << "Node " << (NodeNO > 2 ? 2 : NodeNO) << ": " << JK.x << ", " << JK.y << endl;

    //---test kernel--------------

    thrust::host_vector<cuDFNsys::Triangle_r<data_type_>> hostV(1);
    hostV[0] = HH;
    //cout << "host_vec: " << hostV[0].Coordinate[0].x << ", " << hostV[0].Coordinate[0].y << endl;

    thrust::device_vector<cuDFNsys::Triangle_r<data_type_>> DevV(1);
    DevV = hostV;
    // cout << "dev_vec: " << DevV[0].Coordinate[0].x << ", " << DevV[0].Coordinate[0].y << endl;
    // do not uncomment the above sentence, it is stupid

    cuDFNsys::Triangle_r<data_type_> *PntD = thrust::raw_pointer_cast(DevV.data());
    // cout << "devPnter_vec: " << PntD[0].Coordinate[0].x << ", " << PntD[0].Coordinate[0].y << endl;
    // do not uncomment the above sentence, it is stupid

    TestKernel<<<1, 32>>>(PntD, 1);
    cudaDeviceSynchronize();
    hostV = DevV;
    HH = hostV[0];

    cout << "After kernel, the first node/end of the triangle: " << HH.Coordinate[0].x << ", " << HH.Coordinate[0].y << endl;
    return 0;
};
