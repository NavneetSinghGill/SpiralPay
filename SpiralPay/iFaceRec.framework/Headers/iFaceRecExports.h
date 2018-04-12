//!
//!@file    iFaceRecExports.h
//!
//!@brief   Declares the iFaceRecExports interface.
//!
//!         Copyright (c) 2013 Imagus. All rights reserved.
//!



#pragma once
#if !defined __IFACEAPI_EXPORTS_H__ 
#define __IFACEAPI_EXPORTS_H__ 

#if defined (_MSC_VER)
    #if defined(iFaceRec_EXPORTS)
        #define  IFACEAPI  __declspec(dllexport) 
        #define  DEPRECATED_IFACEAPI  __declspec(dllexport,deprecated) 
    #else
        #define  IFACEAPI  __declspec(dllimport) 
        #define  DEPRECATED_IFACEAPI  __declspec(dllimport,deprecated) 
    #endif // iFaceRec_EXPORTS
#else // defined (_MSC_VER)
    #if defined(iFaceRec_EXPORTS)
        #define IFACEAPI __attribute__((visibility("default")))
    #else
        #define IFACEAPI
    #endif

    #if defined(__GNUC__)
        #define DEPRECATED_IFACEAPI __attribute__ ((deprecated)) 
    #else 
    #define DEPRECATED_IFACEAPI 
        #pragma message("DEPRECATED is not defined for this compiler") 
    #endif 


#endif

#endif //__IFACEAPI_EXPORTS_H__ 
