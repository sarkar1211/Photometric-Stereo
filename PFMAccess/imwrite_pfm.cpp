#include <stdio.h>
#include <stdlib.h>
#include "string.h"
#include "PFMAccess.h"
#include "mex.h"
#ifndef mwSize 
#define mwSize int 
#endif 

template <class T>
void copy_data_from_rgba(T *im, float *pixels, int height, int width)
{
    int x,y;
    for (x=0; x<width; x++) {
        for (y=0; y<height; y++) {
            im[y+x*height] = pixels[0+3*x+3*y*width];
            im[y+x*height+width*height] = pixels[1+3*x+3*y*width];
            im[y+x*height+2*width*height] = pixels[2+3*x+3*y*width];
        }
    }
}
template <class T>
void write_data_to_rgba(float *pixels, const T *im, int height, int width)
{
    int x,y;
    for (x=0; x<width; x++) {
        for (y=0; y<height; y++) {
            pixels[0+3*x+3*y*width] = static_cast<const float>(im[y+x*height]);
            pixels[1+3*x+3*y*width] = static_cast<const float>(im[y+x*height+width*height]);
            pixels[2+3*x+3*y*width] = static_cast<const float>(im[y+x*height+2*width*height]);
        }
    }
}

bool SaveToFile(char* fn, const float *data, int height,int width)
{
    if(data == NULL)
        return false;

    FILE * fp = fopen(fn,"wb");
    if(fp == NULL)
        return false;

    fprintf(fp ,"PF\x0a%d\x0a%d\x0a-1.000000\x0a",width, height);

    if(fwrite(data, sizeof(float), 3*width*height,fp) != 3*width*height)
    {
        fclose(fp);
        return false;
    }

    fclose(fp);
    return true;
}


void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
    // Validate input
    if (nrhs < 2)
        mexErrMsgTxt("Not enough inputs.");
    if (!mxIsChar(prhs[1]))
        mexErrMsgTxt("Invalid inputs.");

    // Extract filename
    int strlen_filename = mxGetM(prhs[1])*mxGetN(prhs[1]) + 1;
    //char filename[strlen_filename];
    char* filename = (char*)mxMalloc(strlen_filename*sizeof(char));
    mxGetString(prhs[1],filename,strlen_filename);

    const mxArray *matImage = prhs[0];

    // read data
    int height = mxGetM(matImage);
    int width  = mxGetN(matImage)/3;

    float * m_data = NULL;
   
    m_data = new float[3*width*height];

    if ( mxSINGLE_CLASS == mxGetClassID(matImage)) {
        const float *matImageData_f = static_cast<const float*>(mxGetData(matImage));
        write_data_to_rgba<float>(m_data, matImageData_f, height, width);
    }
    else if (mxDOUBLE_CLASS == mxGetClassID(matImage)) {
        const double *matImageData_d = mxGetPr(matImage);
        write_data_to_rgba<double>(m_data, matImageData_d, height, width);
    }

    

    // Open image / process image
    //int width, height;
    //try {
    //load data from the file
    if ( !SaveToFile(filename, m_data, height, width))
    {
        mexErrMsgTxt("Write File Error\n");
        exit(1);
    }
  
    if (m_data)
        delete[] m_data;
    // Free temporary array
    mxFree(filename);

    //} //catch(const exception exc) {
    // mexErrMsgTxt("Error reading image file.");
    // }

    return;
}

