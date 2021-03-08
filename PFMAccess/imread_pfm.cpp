#include <stdio.h>
#include <stdlib.h>
#include "string.h"
//#include "PFMAccess.h"
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


int ReadPFMHead(FILE * pFile, int* width,int* height)
{
	char Header[513];
	fseek(pFile, 0, SEEK_SET);
	int	len = fread(Header, sizeof(char), 512, pFile);
	Header[len] = 0;

	if(len > 3)
	{
		Header[len-1] = 0;
		if( (Header[0] == 'P' && Header[1] == 'F') || 
			(Header[0] == 'p' && Header[1] == 'f') )
		{
			char* p = strchr(Header,0xa);
			if(p)
			{
				p++;

				//for the read of pfm file generated from photoshop
				int cx, cy;
				char* end;
				end = strchr(p,0xa);
				end = &(end[1]);
				end = strchr(end,0xa);
				end[0] = 0;
				if(sscanf(p,"%d %d", &cx,&cy)==2)
				{
					*width	= cx;
					*height	= cy;
					p = &end[1];
					end = strchr(p,0xa);
					if(end)
					{
						return (end-Header)+1;
					}

				}

            
            } //if(p)
		} //if(Header)
	}// if (len)
	return 0;
}


void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
  // Validate input
  if (nrhs < 1)
    mexErrMsgTxt("Not enough inputs.");
  if (!mxIsChar(prhs[0]))
    mexErrMsgTxt("Invalid inputs.");

  // Extract filename
  int strlen_filename = mxGetM(prhs[0])*mxGetN(prhs[0]) + 1;
  //char filename[strlen_filename];
  char* filename = (char*)mxMalloc(strlen_filename*sizeof(char));
  mxGetString(prhs[0],filename,strlen_filename);

  // Open image / process image
  //int width, height;
  //try {
	//load data from the file
	  float * m_data = NULL;
	  int width;
	  int height;
	  FILE * fp = fopen(filename,"rb");
	  if(fp == NULL)
	  {
		  mexErrMsgTxt("File Open Error");
		  exit(1);
	  }
	  int dataStartPos = ReadPFMHead(fp, &width, &height);
	  if(dataStartPos == 0)
	  {
		  fclose(fp);
		  mexErrMsgTxt("File Head Read Error");
		  exit(1);
	  }
	  fseek(fp,dataStartPos,SEEK_SET);
	  m_data = new float[3*width*height];
	  if(fread(m_data,sizeof(float),3*width*height,fp) != 3*width*height)
	  {
		  delete []m_data;
		  m_data =NULL;
		  fclose(fp);
		  mexErrMsgTxt("File Body Read Error");
		  exit(1);
	  }
	  fclose(fp);



    // Determine image size
    //width = pfmImg.GetWidth();
    //height = pfmImg.GetHeight();

    // Copy data into output matrix of floats
    mwSize dims[3]; dims[0] = height; dims[1] = width; dims[2] = 3;
    plhs[0] = mxCreateNumericArray(3, dims, mxSINGLE_CLASS, mxREAL);
    if (!plhs[0]) {
      mexErrMsgTxt("Unable to allocate output array.");
    }
    float *im = (float *)mxGetPr(plhs[0]);
    copy_data_from_rgba(im,m_data,height,width);
	if (m_data) {
		delete[] m_data;
		m_data = NULL;
	}
    // Free temporary array
    mxFree(filename);

  //} //catch(const exception exc) {
    // mexErrMsgTxt("Error reading image file.");
    // }
    
  return;
}

