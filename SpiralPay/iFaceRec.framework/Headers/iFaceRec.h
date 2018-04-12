//!
//! @file    iFaceRec.h
//!
//! @brief   Declares the iFaceRec interface.
//!
//!         Copyright (c) 2013 Imagus. All rights reserved.
//!

#if !defined __IMAGUS_FACE_ENGINE_API__
#define __IMAGUS_FACE_ENGINE_API__

#include "iFaceRecDefs.h"
#include "iFaceRecExports.h"
#include <stdint.h>

#ifdef __cplusplus
#define DEFAULTPARAM = 0
extern "C" {
#else
#define DEFAULTPARAM
#endif

/**
@brief Return the last error which occured on the current thread as a string.

This string is only applicible to the previous funtion called from this API on the same thread.
Some errors are only reperesented by an error code if the string would be redundant.
@return Error message as a string. 

@note This string is only valid until the next API method called on the same thread.
@ingroup err
*/
IFACEAPI const char *ifr_GetLastError(void);

/**
Return the last error which occured on the current thread as an error code.

This code only applicible to the previous function called from this API on the same thread.
@return Error message as an error code
@ingroup err
*/
IFACEAPI IFR_RETURN ifr_GetLastErrorCode(void);

/**
    Sets the active Handle counter mode.

    use #IFR_LEAK_RESET to enable / reset the leak count
    use #IFR_LEAK_OFF to disabled the counter
    use #ifr_CountLeaks to get the leak count
  @ingroup leaks
*/
IFACEAPI void ifr_SetLeakDetector(IFR_LEAK status ///< flag to enable/disable/reset leak recorder
                                  );
/**
    Counts current HANDLES.

    Retreives a count of all HANDLES created and not #ifr_Free'd since the last time #ifr_SetLeakDetector was called with the mode #IFR_LEAK_RESET
    
    @return the current active handle count. 
  @ingroup leaks
*/
IFACEAPI int32_t ifr_CountLeaks(void);

/**
Sets the path and filename of the licence file

@param [in] LicenceFileName  a string containing the path and filename of the licence file.

@return IFR_SUCCESS
@ingroup lic
*/
IFACEAPI IFR_RETURN ifr_SetLicenceFileName(const char *LicenceFileName);

/**
Clears all licencing so the application is again unlicenced

@return IFR_SUCCESS
@ingroup lic
*/
IFACEAPI IFR_RETURN ifr_ClearLicence();


/**
Return the current licence file name
@return Current licence file name

@note This string is only valid until the next time this function is called.
@ingroup lic
*/
IFACEAPI const char *ifr_GetLicenceFileName();

/**
Gets the unique host Id for this machine as a string.

@note the output pointer will always point to a valid C string, even if there's an error.
This string will be stable until the next call to this function.

@return the host ID 
@ingroup lic
*/
IFACEAPI const char *ifr_GetLicenceHostID(void);

/**
Gets licence information.

@note the output pointer will always point to a valid C string, even if there's an error.
This string will be stable until the next call to this function.

@return string describing the current licence
@ingroup lic
*/
IFACEAPI const char *ifr_GetLicenceInfo(void);

/**
Gets licence name.

@note the output pointer will always point to a valid C string, even if there's an error.
This string will be stable until the next call to this function.

@return string describing the current licence name
@ingroup lic
*/
IFACEAPI const char *ifr_GetLicenceName(void);

/**
Gets licence company.

@note the output pointer will always point to a valid C string, even if there's an error.
This string will be stable until the next call to this function.

@return string describing the current licence company
@ingroup lic
*/
IFACEAPI const char *ifr_GetLicenceCompany(void);

/**
Gets licence email.

@note the output pointer will always point to a valid C string, even if there's an error.
This string will be stable until the next call to this function.

@return string describing the current licence email
@ingroup lic
*/
IFACEAPI const char *ifr_GetLicenceEmail(void);

/**
Gets licence expiry date.

@return IFR_TIME describing the current licence expiry date
@ingroup lic
*/
IFACEAPI IFR_TIME ifr_GetLicenceExpiry(void);

/**
Gets licence creation date.

@return IFR_TIME describing the current licence creation date
@ingroup lic
*/
IFACEAPI IFR_TIME ifr_GetLicenceCreated(void);


/*! 
Tests To see if a particular module is licenced by the current licence file


@return #IFR_SUCCESS if the module is licenced, #IFR_LICENCE_ERROR if it's not
@ingroup lic
*/
IFACEAPI IFR_RETURN ifr_TestLicence(const char *licence_module_name ///< The name of the licence module to test for
                                    );

/**
Check if a particular module is licenced

@param moduleName The name of the module to check for.

@return #IFR_SUCCESS if the module is licenced, #IFR_LICENCE_ERROR if it's not
@ingroup lic
*/
IFACEAPI IFR_RETURN ifr_LicenceIsModuleLicenced(const char *moduleName ///< The name of the licence module to test for
                                                );

/**
Get the version number of a licenced module


@return version number (as string) if sucessful, or nullptr if there was a problem (check the last error if so)

@ingroup lic*/
IFACEAPI const char *ifr_LicenceGetModuleVersion(const char *moduleName ///< The name of the licence module to test for
                                                 );

/**
Retreives any data a licenced module may have (as a string)
@note the output pointer will always point to a valid C string, even if there's an error.
This string will be stable until the next call to this function.

@return A string containing the data sucessful, or nullptr if there was a problem (check the last error if so)

@ingroup lic*/
IFACEAPI const char *ifr_LicenceGetModuleData(const char *moduleName ///< The name of the licence module to test for
                                              );

/*! @todo {}*/
IFACEAPI IFR_RETURN ifr_LicenceSetCompletionCallback(IFR_CompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);

/**
@todo
If a licence error has occurred then this function will attempt to update/renew
the licence from our licencing servers using your existing credentials.
This is a blocking call that may take some time.

@return #IFR_SUCCESS if the licence can be renewed/updated, #IFR_LICENCE_ERROR otherwise

@ingroup lic*/
IFACEAPI IFR_RETURN ifr_LicenceUpdateFromServer(void);

/**
Request a new licence from our server based on credentials (which you have already supplied to us.)
This is a blocking call that may take some time.
For this to succeeded a valid path/name needs to have been supplied to #ifr_SetLicenceFileName()

@param emailAddress A string containing the email address of the person responsible for this licence
@param companyName  The name of the company requesting the licence
@param userName     The name of the person requesting the licence

@return #IFR_SUCCESS if the licence can be renewed/updated, #IFR_LICENCE_ERROR otherwise
@ingroup lic*/
IFACEAPI IFR_RETURN ifr_LicenceRequestNewLicence(const char *emailAddress, const char *companyName, const char *userName);

/**
Creates an iFaceRec Database connection.

This will create a version of the iFaceRecogniser engine.
This context needs to be supplied to most functions which interact with the face recognizer.

@code
IFR_CONTEXT_HANDLE context = ifr_CreateFaceRec("C:\database.db3",Imagus::IFR_DB_CREATE);
if(context == nullptr)
{
    IFR_RETURN result = ifr_GetLastErrorCode();
}
@endcode

@return             		The handle to the database context created, null if error occured or the callback was specified use #ifr_GetLastErrorCode and #ifr_GetLastError to determine error condition
@ingroup facedb
*/
IFACEAPI IFR_CONTEXT_HANDLE ifr_CreateFaceRec(const char *dbConnectionString,                     ///<The database connection string.
                                              IFR_DB_FLAGS flags,                                 ///<The flags controlling how the database is opened.
                                              IFR_FaceRecCompletionRoutine callback DEFAULTPARAM, ///<Callback function to be called when operation completes asynchronously if non-null. Null implies synchronous call.
                                              void *user DEFAULTPARAM,                            ///<Opaque user variable passed through to the callback.
                                              IFR_ProgressRoutine progress DEFAULTPARAM           ///<Callback function which may be called to update client on progress of call. the floating point value will cycle between 0.0 and 1.0 to denote progress. It will also return a copy of the user parameter. this callback may never get called, and also is guranteed never to be called after the completion routine has been called. @note this function returning 1.0 does not denote completion, only the completion routine does that.
                                              );


/**
Creates an iFaceRec Database connection.

This will create a version of the iFaceRecogniser engine.
This context needs to be supplied to most functions which interact with the face recognizer.
This version can take an optional database schema identifier which will make a new schema in databases that support this.
This means within the same physical database you can have multiple independent face tables.
This will throw an error if it is used on a database type which cannot support schemas.
Current the only one which does is PostgreSQL

@code
IFR_CONTEXT_HANDLE context = ifr_CreateFaceRec2("C:\database.db3",Imagus::IFR_DB_CREATE,"MyScheme");
if(context == nullptr)
{
IFR_RETURN result = ifr_GetLastErrorCode();
}
@endcode

@rethandle{IFR_CONTEXT_HANDLE}
@ingroup facedb
*/
IFACEAPI IFR_CONTEXT_HANDLE ifr_CreateFaceRec2(const char *dbConnectionString,                     ///<The database connection string.
	IFR_DB_FLAGS flags,   ///<The flags controlling how the database is opened.
	const char * schema, ///< A unique identifier in the database to generate the tables in 
	IFR_FaceRecCompletionRoutine callback DEFAULTPARAM, ///<Callback function to be called when operation completes asynchronously if non-null. Null implies synchronous call.
	void *user DEFAULTPARAM,                            ///<Opaque user variable passed through to the callback.
	IFR_ProgressRoutine progress DEFAULTPARAM           ///<Callback function which may be called to update client on progress of call. the floating point value will cycle between 0.0 and 1.0 to denote progress. It will also return a copy of the user parameter. this callback may never get called, and also is guranteed never to be called after the completion routine has been called. @note this function returning 1.0 does not denote completion, only the completion routine does that.
);


/** get the unique identifer of the database, used in master slave relationships
@handleparam{IFR_CONTEXT_HANDLE,context}
@callbackparam{IFR_UUIDCompletionRoutine,callback}
@userparam
@return a new #IFR_UUID with the unique identifier of the database, or if NullUUID a failure or it was deferred. see #ifr_GetLastErrorCode and #ifr_GetLastError
@ingroup facedb
*/
IFACEAPI IFR_UUID ifr_GetDbId(IFR_CONTEXT_HANDLE context, IFR_UUIDCompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);


/** returns the master / slave status of the database 
@handleparam{IFR_CONTEXT_HANDLE, context}
@callbackparam{IFR_CompletionRoutine, callback}
@userparam
@return #IFR_TRUE if the database is a master, or #IFR_FALSE if it is a slave, #IFR_DEFERED if the call was deffered
*/
IFACEAPI IFR_RETURN ifr_GetIsMaster(IFR_CONTEXT_HANDLE context, IFR_CompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);

/** Sets the database up as a slave to a specified master database
All modifications to a slave database will get sent to the master when the upload to master synchronisation routines are used.
All updates to a master will get synchnised back to the slaves. 
@warning This will not wipe the local database unless the #IFR_MASTERSLAVE_WIPE_CURRENT_CONTENTS flag is applied. If this flag is not set, all the current contents will get replicated to the master. 
@handleparam{IFR_CONTEXT_HANDLE, context}
@param masteruuid uuid if the master database to be a slave to.
@param flags used to modify slave actions, for example, to keep current db contents, to upload to a master pass the IFR_WIPE_CONTENTS flag
@callbackparam{IFR_CompletionRoutine, callback}
@userparam
@deferred_return
@ingroup facedb
*/

IFACEAPI IFR_RETURN ifr_SetAsSlave(IFR_CONTEXT_HANDLE context, IFR_UUID masteruuid, IFR_MASTERSLAVE_FLAGS flags, IFR_CompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);



/*! Retrieves size of connection pool in use.

@return the size of the connection pool
@ingroup facedb
*/
IFACEAPI size_t ifr_GetConnectionPoolCount(IFR_CONTEXT_HANDLE context /*!< The database context*/);

/**
Sets the location of a configuration directory, it must be called before any other library calls are made.
@note This function is internally refererance counted, any subsequant call to #ifr_Initialise before and #ifr_Shutdown call is made will have its arguments ignored, however for every #ifr_Initialise called, there must be a corresponding call to #ifr_Shutdown for the system to shutdown cleanly.

@param  configFolder   can be null, on windows by default the config directory is the application directory, or on linux it is @code{.sh}/usr/local/share/Imagus/ @endcode This is where the app looks for models. If a custom installation is created which moves models about this may need to be changed.

@param  tempDirectory   Pathname of the temporary directory. ( can be null, to use system default
temp directory, sometimes the system temp directory is not good enough,
some android devices do not have this set up, and the program will fail
with a database error when creating or loading a database, if this occurs,
try explicitly setting the temp directory)

@param  cacheDirectory  The cache directory is a directory which may be used to cache files which can be recreated when necessary. These can be deleted at anytime, but they may be recreated by the SDK.   (can be null, caching will occur in temp directory, this may be wiped on a system restart)

@ifr_return


@ingroup init
*/
IFACEAPI IFR_RETURN ifr_Initialise(const char *configFolder, const char *tempDirectory, const char *cacheDirectory);

/** 

Checks to see if the library has been sucessfully initialised
@return IFR_TRUE or IFR_FALSE
@ingroup init
*/
IFACEAPI IFR_RETURN ifr_isInitialsed();

/**
This tells the api it is about to be terminiated. This will block untill all outstanding callbacks have completed,
and all databases will be fully closed/transactions completed.

It will give up after ~10seconds of waiting, as this likely means that a device HANDLE was not Free'd.

It is not imperative to call this function, but when it has finished it ensures that all internally allocated memory is freed and memory analisers such as valgrind should not complain.
This function needs to be called once for every outstanding #ifr_Initialise that was called before it is effective

@return An IFR_RETURN error code
@ingroup init
*/

IFACEAPI IFR_RETURN ifr_Shutdown(void);

/**
Frees a handle created by this library

Use this on all _HANDLEs returned by this library when you no longer need
them.  This includes handles returned by functions such as ifr_FaceListGetFace
since every handle returned is a unique reference to the underlying
object.

@code
IFR_CONTEXT_HANDLE context = ifr_CreateFaceRec("C:\database.db3",Imagus::IFR_DB_CREATE);
...
ifr_Free(context);
@endcode

@param ptr A handle created by this library (any type)

@return IFR_SUCCESS.
@ingroup handles
*/
IFACEAPI IFR_RETURN ifr_Free(const IFR_HANDLE ptr);


/*! @ingroup params
@{*/
IFACEAPI IFR_RETURN ifr_SetParameter(const IFR_HANDLE handle, const char *key, void *value, IFR_VARTYPE type);
IFACEAPI void *ifr_GetParameter(const IFR_HANDLE handle, const char *key, IFR_VARTYPE *type);
IFACEAPI IFR_HANDLE ifr_GetParameterOptions(const IFR_HANDLE handle, const char *key, IFR_VARTYPE * type);
IFACEAPI IFR_PARAMETERLIST_HANDLE ifr_ListParameters(const IFR_HANDLE handle);
IFACEAPI const IFR_PARAMETER *ifr_GetParameterDefinition(IFR_PARAMETERLIST_HANDLE handle, size_t index);
IFACEAPI size_t ifr_GetNumParameters(IFR_PARAMETERLIST_HANDLE handle);
IFACEAPI IFR_RETURN ifr_SetParameterChangedNotification(const IFR_HANDLE handle, IFR_ParameterUpdateRoutine callback, IFR_CALLBACK_HANDLE cbHandle);
/*!@}*/

/**
Duplicates a handle, such that two handles now exist pointing to the same object. @note
that both still need to be freed using ifr_Free.

@param  h   The pointer to the handle to duplicate.

@return null if it fails, else a new handle.
@ingroup handles
*/
IFACEAPI IFR_PERSON_HANDLE ifr_DuplicatePersonHandle(const IFR_PERSON_HANDLE h);

/**
Duplicates a handle, such that two handles now exist pointing to the same object. @note
that both still need to be freed using ifr_Free.

@param  h   The pointer to the handle to duplicate.

@return null if it fails, else a new handle.
@ingroup handles
*/
IFACEAPI IFR_SEARCH_HANDLE ifr_DuplicateSearchHandle(const IFR_SEARCH_HANDLE h);

/**
Duplicates a handle, such that two handles now exist pointing to the same object. @note
that both still need to be freed using ifr_Free.

@param  h   The pointer to the handle to duplicate.

@return null if it fails, else a new handle.
@ingroup handles

*/
IFACEAPI IFR_FACE_HANDLE ifr_DuplicateFaceHandle(const IFR_FACE_HANDLE h);

/**
Duplicates a handle, such that two handles now exist pointing to the same object. @note
that both still need to be freed using ifr_Free.

@param  h   The pointer to the handle to duplicate.

@return null if it fails, else a new handle.
@ingroup handles

*/
IFACEAPI IFR_FACELIST_HANDLE ifr_DuplicateFacelistHandle(const IFR_FACELIST_HANDLE h);

/**
Duplicates a handle, such that two handles now exist pointing to the same object. @note
that both still need to be freed using ifr_Free.

@param  h   The pointer to the handle to duplicate.

@return null if it fails, else a new handle.
@ingroup handles

*/
IFACEAPI IFR_CONTEXT_HANDLE ifr_DuplicateContextHandle(const IFR_CONTEXT_HANDLE h);

/**
Duplicates a handle, such that two handles now exist pointing to the same object. @note
that both still need to be freed using ifr_Free.

@param  h   The pointer to the handle to duplicate.

@return null if it fails, else a new handle.
@ingroup handles

*/
IFACEAPI IFR_IMAGE_HANDLE ifr_DuplicateImageHandle(const IFR_IMAGE_HANDLE h);

/**
Duplicates a handle, such that two handles now exist pointing to the same object. @note
that both still need to be freed using ifr_Free.

@param  h   The pointer to the handle to duplicate.

@return null if it fails, else a new handle.
@ingroup handles

*/

IFACEAPI IFR_DETECTOR_RESULT_HANDLE ifr_DuplicateDetectorResultHandle(const IFR_DETECTOR_RESULT_HANDLE h);


/** Creates an empty detector handle for other detectors to use when running a tracker.

@rethandle{IFR_DETECTOR_RESULT_HANDLE}
*/
IFACEAPI IFR_DETECTOR_RESULT_HANDLE ifr_AllocDetectorResult();

/**
Adds a set of eyes to a detector result handle. This is useful if adding a single
detection at a time. Ideally use Add Detection and fill all of the details out, but if you only have the eye locations, use this.

@param  h      The pointer to the handle to add results to.
@param  eyes   The eyes to add to the handle.
@param trackID The unique Id of the track the eyes belong to, if this is NullUUID, the internal tracked will be used.

@ifr_return
@ingroup handles

*/
IFACEAPI IFR_RETURN ifr_DetectorResultAddEyes(IFR_DETECTOR_RESULT_HANDLE h, IFR_EYES eyes, IFR_UUID trackID);


/**
Adds a detector result to a detector result handle. This is useful if adding a single
detection at a time.

@param  h        The pointer to the handle to add results to.
@param  result   The result to add to the handle.

@ifr_return
@ingroup handles

*/
IFACEAPI IFR_RETURN ifr_DetectorResultAddResult(IFR_DETECTOR_RESULT_HANDLE h, IFR_DETECTORRESULT *result);

/**
Removes detector results from a detector result handle that contain this UUID. This is useful for removing results
that are no longer valid.

@param  h        The pointer to the handle to add results to.
@param  uuid     The uuid to remove from the result handle.

@ifr_return
@ingroup handles

*/
IFACEAPI IFR_RETURN ifr_DetectorResultRemoveUUID(IFR_DETECTOR_RESULT_HANDLE h, IFR_UUID uuid);

/**
Duplicates a handle, such that two handles now exist pointing to the same object. @note
that both still need to be freed using ifr_Free.

@param  h   The pointer to the handle to duplicate.

@rethandle{IFR_TRACKLET_HANDLE}
@ingroup handles

*/

IFACEAPI IFR_TRACKLET_HANDLE ifr_DuplicateTrackletHandle(const IFR_TRACKLET_HANDLE h);

/**
Duplicates any handle, such that two handles now exist pointing to the same object. @note
that both still need to be freed using ifr_Free.

@param  handle   The pointer to the handle to duplicate.

@return null if it fails, else a new handle, this needs casting to the same type as was passed in
@ingroup handles

*/

IFACEAPI void *ifr_Duplicate(const void *handle);

/**
Allocate a new person object

Creates a new person object, and returns a handle to it.

@rethandle{IFR_PERSON_HANDLE}

@ingroup facedb
*/
IFACEAPI IFR_PERSON_HANDLE ifr_AllocPerson(void);

/**
Allocate a new person object, using a user supplied UUID 

Creates a new person object, and returns a handle to it.

@rethandle{IFR_PERSON_HANDLE}
@ingroup facedb
*/
IFACEAPI IFR_PERSON_HANDLE ifr_AllocPerson2(IFR_UUID pid);

/**
Creates a new facelist object.

@rethandle{IFR_FACELIST_HANDLE}
@ingroup facelist
*/
IFACEAPI IFR_FACELIST_HANDLE ifr_AllocFaceList(void);

/**
Returns the number of faces in a facelist.

@code
IFR_FACELIST_HANDLE h = ifr_AllocFaceList();
size_t n = ifr_FaceListGetNumberOfFaces(h);
@endcode
@param fl_handle  The Facelist handle
@return the number of faces in the facelist.
@ingroup facelist
*/
IFACEAPI size_t ifr_FaceListGetNumberOfFaces(IFR_FACELIST_CHANDLE fl_handle );

/**
Returns a single face from a facelist.

@code
// Get first face in list

IFR_FACE_HANDLE face = NULL;
if(ifr_FaceListGetNumberOfFaces(facelist) >0)
{
    face = ifr_FaceListGetFace(facelist, 0);
}
...
ifr_Free(face);
@endcode

@param fl_handle The Facelist handle
@param index a zero based index of the face to return

@rethandle{IFR_FACE_HANDLE}
@ingroup facelist
*/
IFACEAPI IFR_FACE_HANDLE ifr_FaceListGetFace(IFR_FACELIST_CHANDLE fl_handle, size_t index);

/**
Creates a new Search handle.
@rethandle{IFR_SEARCH_HANDLE}
@ingroup search
*/
IFACEAPI IFR_SEARCH_HANDLE ifr_AllocSearch(void);

/**
Create a new Image from raw bitmap data

@deprecated use ifr_CreateImage3 instead

This function creates an image handle suitable for use in the library from raw data.
This is useful if you already have the image data in memory and do not want to copy it to use it.

@note the image memory supplied in imageData is not copied, and is required to stay available unmodified 
	  between the call to the function and the subsequent callback to the deleter function. if this 
	  memory is deleted externally before the deleter callback is called, undefined behaviour will result

@outhandleparam{IFR_IMAGE_HANDLE, image}
@param imageData   The raw image data.
@param format      The pixel format. (see #IFR_IMAGE_FORMAT) e.g #IFR_BGR
@param width       The width in pixels.
@param height      The height in pixels.
@param widthStep   The stride of the image in bytes, that is the number of bytes between the first pixel on one row, to the first pixel on the next,
                   a 10 pixel wide image with a 24bpp with no alignment issues has a stride of 30 bytes. if the image rows are aligned to 8 byte boundaries it would have a stride of 32 bytes  

@param pixelAspect The pixel aspect ratio.
@param deleter     If non-null, the function to use to delete the imageData when finished with.
				   the first parameter is the imageData pointer supplied and the second is the 
				   deleterCtx user data supplied to this funtion.
@param deleterCtx  the opaque user parameter which gets passed to the deleter function when called, (In cpp use this to pass the original object handle).


@code
    size_t width = 100;		    // width of the image in pixels
    size_t height = 100;	    // height of the image in pixels
    size_t width_step = 304;    // stride of the image in bytes (if the bitmap is a 24 bits per pixel format, and aligned to an 8 byte boundary)
    float aspect_ratio = 1.0f;  // the pixels are square ( this may not be the case, as this gives us hints for analytics)

    unsigned char * data  = malloc(width_step * height); // create new array of correct size for image

    IFR_IMAGE_HANDLE image = NULL;
    ifr_CreateImage(&image,data,IFR_BGR,width,height,width_step,aspect_ratio,delete_carray_image,data);
    ...
    ifr_Free(image);
@endcode

And the deleter function required to delete the memory alocated
In this example you could free either the imageData or the user value, as we pass the same value into both.
The reason both exist is so that we can pass a value for the image data that is different from the object that owns it and needs to be freed
@code
void delete_carray_image(unsigned char * imageData, void * user)
{
	free(user);
	printf("Image data has been freed\n");
}
@endcode

@warning the resultant image handle \b must be freed with #ifr_Free

@ifr_return
@ingroup images
*/

DEPRECATED_IFACEAPI IFR_RETURN ifr_CreateImage(IFR_IMAGE_HANDLE *image,
                                    unsigned char *imageData,
                                    IFR_IMAGE_FORMAT format,
                                    size_t width,
                                    size_t height,
                                    size_t widthStep,
                                    float pixelAspect,
                                    void (*deleter)(unsigned char *, void *ctx),
                                    void *deleterCtx);

/**
Create a new Image from raw bitmap data

@deprecated use ifr_CreateImage3 instead

This function creates an image handle suitable for use in the library from raw data.
This is useful if you already have the image data in memory and do not want to copy it to use it.

@note the image memory supplied in imageData is not copied, and is required to stay available unmodified 
	  between the call to the function and the subsequent callback to the deleter function. if this 
	  memory is deleted externally before the deleter callback is called, undefined behaviour will result


@outhandleparam{IFR_IMAGE_HANDLE, image}
@param imageData   The raw image data.
@param format      The pixel format. (see #IFR_IMAGE_FORMAT) e.g #IFR_BGR
@param width       The width in pixels.
@param height      The height in pixels.
@param widthStep   The stride of the image in bytes, that is the number of bytes between the first pixel on one row, to the first pixel on the next,
                   a 10 pixel wide image with a 24bpp with no alignment issues has a stride of 30 bytes. if the image rows are aligned to 8 byte boundaries it would have a stride of 32 bytes  

@param pixelAspect The pixel aspect ratio.
@param time         The @ref time the image was created.
@param creationdata user defined string reperesenting data which is constant throughout all image manipulations.( including crop and rotate)
@param deleter     If non-null, the function to use to delete the imageData when finished with.
				   the first parameter is the imageData pointer supplied and the second is the 
				   deleterCtx user data supplied to this funtion.
@param deleterCtx  the opaque user parameter which gets passed to the deleter function when called, (In cpp use this to pass the original object handle).


@code
    size_t width = 100;		    // width of the image in pixels
    size_t height = 100;	    // height of the image in pixels
    size_t width_step = 304;    // stride of the image in bytes (if the bitmap is a 24 bits per pixel format, and aligned to an 8 byte boundary)
    float aspect_ratio = 1.0f;  // the pixels are square ( this may not be the case, as this gives us hints for analytics)

    unsigned char * data  = malloc(width_step * height); // create new array of correct size for image

    IFR_IMAGE_HANDLE image = NULL;
    ifr_CreateImage2(&image,data,IFR_BGR,width,height,width_step,aspect_ratio,IFR_DATETIMENOW,NULL,delete_carray_image,data);
    ...
    ifr_Free(image);
@endcode

And the deleter function required to delete the memory alocated
In this example you could free either the imageData or the user value, as we pass the same value into both.
The reason both exist is so that we can pass a value for the image data that is different from the object that owns it and needs to be freed
@code
void delete_carray_image(unsigned char * imageData, void * user)
{
	free(user);
	printf("Image data has been freed\n");
}
@endcode

@warning the resultant image handle \b must be freed with #ifr_Free

@ifr_return
@ingroup images
*/

DEPRECATED_IFACEAPI IFR_RETURN ifr_CreateImage2(IFR_IMAGE_HANDLE *image,
                                     unsigned char *imageData,
                                     IFR_IMAGE_FORMAT format,
                                     size_t width,
                                     size_t height,
                                     size_t widthStep,
                                     float pixelAspect,
                                     IFR_TIME time,
                                     const char *creationdata,
                                     void (*deleter)(unsigned char *, void *ctx),
                                     void *deleterCtx);


/**
Create a new Image from raw bitmap data

This function creates an image handle suitable for use in the library from raw data.
This is useful if you already have the image data in memory and do not want to copy it to use it.

@note the image memory supplied in imageData is not copied, and is required to stay available unmodified 
	  between the call to the function and the subsequent callback to the deleter function. if this 
	  memory is deleted externally before the deleter callback is called, undefined behaviour will result

@param imageData   The raw image data.
@param format      The pixel format. (see #IFR_IMAGE_FORMAT) e.g #IFR_BGR
@param width       The width in pixels.
@param height      The height in pixels.
@param widthStep   The stride of the image in bytes, that is the number of bytes between the first pixel on one row, to the first pixel on the next,
                   a 10 pixel wide image with a 24bpp with no alignment issues has a stride of 30 bytes. if the image rows are aligned to 8 byte boundaries it would have a stride of 32 bytes  

@param pixelAspect The pixel aspect ratio.
@param time         The @ref time the image was created.
@param creationdata user defined string reperesenting data which is constant throughout all image manipulations.( including crop and rotate)
@param deleter     If non-null, the function to use to delete the imageData when finished with.
				   the first parameter is the imageData pointer supplied and the second is the 
				   deleterCtx user data supplied to this funtion.
@param deleterCtx  the opaque user parameter which gets passed to the deleter function when called, (In cpp use this to pass the original object handle).


@snippet image_deleter.c CreateImage3 Function

And the deleter function required to delete the memory alocated
In this example you could free either the imageData or the user value, as we pass the same value into both.
The reason both exist is so that we can pass a value for the image data that is different from the object that owns it and needs to be freed

@snippet image_deleter.c Deleter Function

@rethandle{IFR_IMAGE_HANDLE}
@ingroup images
*/
IFACEAPI IFR_IMAGE_HANDLE ifr_CreateImage3(unsigned char *imageData,
                                     IFR_IMAGE_FORMAT format,
                                     size_t width,
                                     size_t height,
                                     size_t widthStep,
                                     float pixelAspect,
                                     IFR_TIME time,
                                     const char *creationdata,
                                     void (*deleter)(unsigned char *, void *ctx),
                                     void *deleterCtx);




/**
Gets the image width in pixels
@handleparam{IFR_IMAGE_HANDLE,imageHandle}
@return The image width. @setslasterror
@ingroup images
*/
IFACEAPI size_t ifr_ImageGetWidth(IFR_IMAGE_HANDLE imageHandle);

/**
Gets the image width in pixels
@handleparam{IFR_IMAGE_HANDLE,imageHandle}
@return The image height. @setslasterror
@ingroup images
*/
IFACEAPI size_t ifr_ImageGetHeight(IFR_IMAGE_HANDLE imageHandle);

/**
Gets the widthstep or stride from the image
This is the number of bytes between the first pixel on one row, to the first pixel on the next 
@handleparam{IFR_IMAGE_HANDLE,imageHandle}
@return The stride in bytes. @setslasterror
@ingroup images
*/
IFACEAPI size_t ifr_ImageGetWidthStep(IFR_IMAGE_HANDLE imageHandle);

/**
Returns the image UUID of the image, any two images that are identical will return the same UUID
This includes images where one image is a copy of another with an applied roi
@handleparam{IFR_IMAGE_HANDLE,imageHandle}
@return The image UUID. @setslasterror
@ingroup images
*/
IFACEAPI IFR_UUID ifr_ImageGetUUID(IFR_IMAGE_HANDLE imageHandle);

/**
Gets the image pixel aspect ratio from an image object
@handleparam{IFR_IMAGE_HANDLE,imageHandle}
@return The image pixel aspect ratio @setslasterror
@ingroup images
*/
IFACEAPI float ifr_ImageGetPixelAspect(IFR_IMAGE_HANDLE imageHandle);

/**
Gets the image pixel width from an image object
This is the number of bytes used to reperesent a pixel
@handleparam{IFR_IMAGE_HANDLE,imageHandle}
@return The number of bytes each pixel uses. @setslasterror
@ingroup images
*/
IFACEAPI size_t ifr_ImageGetPixelWidth(IFR_IMAGE_HANDLE imageHandle);

/**
Returns the image pixel width ratio from an image format
This is the number of bytes used to reperesent a pixel in this format
@param format An image format setting e.g #IFR_BGRA
@return The number of bytes each pixel uses @setslasterror
@ingroup images
*/
IFACEAPI size_t ifr_GetPixelWidth(IFR_IMAGE_FORMAT format);

/**
Get the raw image data pointer ratio from an image object.
@handleparam{IFR_IMAGE_HANDLE,imageHandle}
@return A pointer to the raw pixel data. @setslasterror
@ingroup images
*/
IFACEAPI unsigned char *ifr_ImageGetDataPointer(IFR_IMAGE_HANDLE imageHandle);

/**
Gets the size in bytes of the data returned by #ifr_ImageGetDataPointer
@handleparam{IFR_IMAGE_HANDLE,imageHandle}
@return A size of data buffer in bytes, this is at least. \f$height * widthstep * pixelformatsize\f$
Thus it may include more information than needed.
@ingroup images
*/
IFACEAPI size_t ifr_ImageGetDataSize(IFR_IMAGE_HANDLE imageHandle);

/**
Copys the raw image pixels to the memory location pointed to by pixelData. 
If the colour format is specified as anything but #IFR_DEFAULT_FORMAT, will do a colour format conversion aswell.

@handleparam{IFR_IMAGE_HANDLE,imageHandle}
@param pixelData a pointer to the buffer to hold the output data this must be a valid memory location of at least \f$ widthStep * height * pixelsize \f$
@param width width of image in pixels
@param height height of image in pixels
@param widthStep width step of image this need to be the width of the image in pixels * the result if #ifr_GetPixelWidth (format) using the requested colour space.
@param format the requested colourspace of the copy image format e.g #IFR_RGB

@ifr_return{this will return #IFR_INVALID_SIZE if any of the input parameter are calculated to be not sensible}
@ingroup images

*/
IFACEAPI IFR_RETURN ifr_ImageCopyTo(IFR_IMAGE_HANDLE imageHandle, void *pixelData, size_t width, size_t height, size_t widthStep, IFR_IMAGE_FORMAT format);



/**
Copys the raw image pixels within the region of interest to the memory location pointed to by pixelData.
If the colour format is specified as anything but #IFR_DEFAULT_FORMAT, will do a colour format conversion too.
aswell.

@handleparam{IFR_IMAGE_HANDLE,imageHandle}
@param roi a rectangle specifying the region you wish to copy
@param pixelData a pointer to the buffer to hold the output data this must be a valid memory location of at least \f$ widthStep * height * pixelsize \f$
@param width width of image in pixels this must be equal to the width of the roi rectangle
@param height height of image in pixels this must be equal to the height of the roi rectangle
@param widthStep width step of image this need to be at least the width of the image in pixels * the result if #ifr_GetPixelWidth (format) using the requested colour space.
@param format the requested colourspace of the copy image format e.g #IFR_RGB

@ifr_return{This will return #IFR_INVALID_SIZE if any of the input parameter are calculated to be not sensible}
@ingroup images
*/
IFACEAPI IFR_RETURN ifr_ImageCopyROITo(IFR_IMAGE_HANDLE imageHandle, IFR_RECT roi, void *pixelData, size_t width, size_t height, size_t widthStep, IFR_IMAGE_FORMAT format);


/** Sets the current region of interest in the current image to be a copy of the passed in bitmap data
@handleparam{IFR_IMAGE_HANDLE,imageHandle}

@param data a pointer to the buffer from which to copy the datato hold the output data this must be a valid memory location of at least \f$ widthStep * height * pixelsize \f$ where pixelsize is determined from the result of #ifr_ImageGetPixelWidth (format)
@param width width of the input image in pixels this must be equal to the width of the roi rectangle
@param height height of the input image in pixels this must be equal to the height of the roi rectangle
@param widthStep width step of input image this need to be at least the width of the image in pixels * the result if #ifr_ImageGetPixelWidth (format) using the requested colour space.
@param format the format for the resulting image. #IFR_IMAGE_FORMAT
@ifr_return{This will return #IFR_INVALID_SIZE if any of the input parameter are calculated to be not sensible}
@ingroup images
*/

IFACEAPI IFR_RETURN ifr_ImageSetPixelArray(IFR_IMAGE_HANDLE imageHandle, void *data, size_t width, size_t height, size_t widthStep, IFR_IMAGE_FORMAT format);

/**
Returns the current image colourspace format from an image object
@handleparam{IFR_IMAGE_HANDLE,imageHandle}
@return The image format (see #IFR_IMAGE_FORMAT)
@ingroup images
*/
IFACEAPI IFR_IMAGE_FORMAT ifr_ImageGetFormat(IFR_IMAGE_HANDLE imageHandle);

/**
@brief  gets the creation @ref time supplied to the #ifr_CreateImage3 function.
This is intended to be the time when the image was taken ( in video or as a photo)
@note   This time persists throughout any image transforms such as cropping or rotating.
@param  imageHandle Handle of the image.  @invalid_is_undefined
@return An IFR_TIME see @ref time
@ingroup images
*/
IFACEAPI IFR_TIME ifr_ImageGetUTCCreationTime(IFR_IMAGE_HANDLE imageHandle);

/**
@fn IFACEAPI const char * ifr_ImageGetCreationData(IFR_IMAGE_HANDLE imageHandle);
@brief  Returns a string with the data passed in at creation time for the image.
@note   This data persists throughout any image transforms such as cropping or rotating.
@param  imageHandle Handle of the image.
@return null if it fails, else a string with the data. @threadlocal
@ingroup images

*/
IFACEAPI const char *ifr_ImageGetCreationData(IFR_IMAGE_HANDLE imageHandle);

/*! Gets Current System @ref time 
@return the current UTC time in milliseconds since 1970-01-01 00:00:00
@ingroup time
*/
IFACEAPI IFR_TIME ifr_GetTimeNow(void);

#if !defined ANDROID
/*! Returns a human readable string for the time in UTC is iso8601 format 
@param time The IFR_TIME
@return a string with the time. @threadlocal
@ingroup time
*/
IFACEAPI const char *ifr_GetTimeAsUTCString(IFR_TIME time);

/*! Returns a human readable string for the time in local time in iso8601 format 
@param time The IFR_TIME
@return a string with the time. @threadlocal
@ingroup time
*/
IFACEAPI const char *ifr_GetTimeAsLocalString(IFR_TIME time);

/*! Returns a human readable string for the time in local time in iso8601 format including the offset from UTC 
@param time The IFR_TIME
@return a string with the time. @threadlocal
@ingroup time
*/
IFACEAPI const char *ifr_GetTimeAsLocalStringWithOffset(IFR_TIME time);

/*! Converts a iso8601 time into an IFR_TIME
@param s The time string e.g "2002-01-20 23:59:59.000"
@return an IFR_TIME
@ingroup time
*/
IFACEAPI IFR_TIME ifr_UTCTimeFromString(const char *s);

#endif // ! defined ANDROID

// not implemented yet
//IFACEAPI const char * ifr_GetTimeAsTimeZoneString(IFR_TIME time, const char * timezoneinfo);

/**
Set the image creation datetime
@handleparam{IFR_IMAGE_HANDLE,imageHandle}
@param time the @ref time to set for this image. 
@ingroup images
*/
IFACEAPI void ifr_ImageSetUTCCreationTime(IFR_IMAGE_HANDLE imageHandle, IFR_TIME time);

/**
Set the image creation data
@handleparam{IFR_IMAGE_HANDLE,imageHandle}
@param dataAsString a string that will be copied internally 
@ingroup images
*/
IFACEAPI void ifr_ImageSetCreationData(IFR_IMAGE_HANDLE imageHandle, const char *dataAsString);

/**
Loads an image from a file,
@deprecated Use ifr_LoadImage3() instead.
Can load most image formats e.g. png, jpeg, tiff, pgm
@outhandleparam{IFR_IMAGE_HANDLE, image}
@param location the path and filename of the image to load.
@param preferred_format the prefered format for the resulting image. #IFR_IMAGE_FORMAT, use #IFR_DEFAULT_FORMAT to load as is
@ifr_return
@warning the resultant image handle \b must be freed with #ifr_Free
@ingroup images
*/
DEPRECATED_IFACEAPI IFR_RETURN ifr_LoadImage(IFR_IMAGE_HANDLE *image, const char *location, IFR_IMAGE_FORMAT preferred_format);


/**
Loads an image from a file,
@deprecated Use ifr_LoadImage3() instead.
Can load most image formats e.g. png, jpeg, tiff, pgm
@outhandleparam{IFR_IMAGE_HANDLE, image}
@param location the path and filename of the image to load.
@param preferred_format the prefered format for the resulting image. #IFR_IMAGE_FORMAT, use #IFR_DEFAULT_FORMAT to load as is
@param time The @ref time the image was created.
@param creationdata user defined string representing data which is constant throughout all image manipulations.( including crop and rotate)
@ifr_return
@warning the resultant image handle \b must be freed with #ifr_Free
@ingroup images
*/

DEPRECATED_IFACEAPI IFR_RETURN ifr_LoadImage2(IFR_IMAGE_HANDLE *image, const char *location, IFR_IMAGE_FORMAT preferred_format, IFR_TIME time, const char *creationdata);

/**
Loads an image from a file,
Can load most image formats e.g. png, jpeg, tiff, pgm
@param location the path and filename of the image to load.
@param preferred_format the prefered format for the resulting image. #IFR_IMAGE_FORMAT, use #IFR_DEFAULT_FORMAT to load as is
@param time The @ref time the image was created.
@param creationdata user defined string representing data which is constant throughout all image manipulations.( including crop and rotate)
@rethandle{IFR_IMAGE_HANDLE}
@ingroup images
*/

IFACEAPI IFR_IMAGE_HANDLE ifr_LoadImage3(const char *location, IFR_IMAGE_FORMAT preferred_format, IFR_TIME time, const char *creationdata);



/**
@deprecated Use #ifr_LoadImageFromBuffer
Creates an image from in-memory data

This function creates an #IFR_IMAGE_HANDLE from a file already loaded into memory.
(Such as a .jpg or .png.) This enables the file to be loaded into memory by the native file system
or embedded into the code without having to use the file system within the IFR library.
@outhandleparam{IFR_IMAGE_HANDLE, image}
@param buffer the start of the memory buffer containing the image file
@param bufferLength the length of the buffer in bytes
@param preferred_format the prefered format for the resulting image. see #ifr_LoadImage3
@ingroup images
@warning the resultant image handle \b must be freed with #ifr_Free
@ifr_return
*/
DEPRECATED_IFACEAPI IFR_RETURN ifr_LoadImageFromMemory(IFR_IMAGE_HANDLE *image, const void *buffer, size_t bufferLength, IFR_IMAGE_FORMAT preferred_format);

/** 
Creates an image from in-memory data

This function creates an #IFR_IMAGE_HANDLE from a file already loaded into memory.
(Such as a .jpg or .png.) This enables the file to be loaded into memory by the native file system
or embedded into the code without having to use the file system within the IFR library.
@outhandleparam{IFR_IMAGE_HANDLE, image}
@param buffer the start of the memory buffer containing the image file
@param bufferLength the length of the buffer in bytes
@param preferred_format the prefered format for the resulting image. see #ifr_LoadImage3
@param time The @ref time the image was created
@param creationdata User supplied creation data.
@ingroup images
@warning the resultant image handle \b must be freed with #ifr_Free
@ifr_return
*/
DEPRECATED_IFACEAPI IFR_RETURN ifr_LoadImageFromMemory2(IFR_IMAGE_HANDLE *image, const void *buffer, size_t bufferLength, IFR_IMAGE_FORMAT preferred_format, IFR_TIME time, const char *creationdata);

/** 
Creates an image from in-memory data held in an #IFR_BUFFER_HANDLE

This function creates an #IFR_IMAGE_HANDLE from a file already loaded into memory.
(Such as a .jpg or .png.) This enables the file to be loaded into memory by the native file system
or embedded into the code without having to use the file system within the IFR library.

@param buffer the #IFR_BUFFER_HANDLE containing the image data
@param preferred_format the prefered format for the resulting image. see #ifr_LoadImage3
@ingroup images

@rethandle{IFR_IMAGE_HANDLE}
*/

IFACEAPI IFR_IMAGE_HANDLE ifr_LoadImageFromBuffer(IFR_BUFFER_HANDLE buffer, IFR_IMAGE_FORMAT preferred_format);


/** 
Creates an image from in-memory data held in an #IFR_BUFFER_HANDLE

This function creates an #IFR_IMAGE_HANDLE from a file already loaded into memory.
(Such as a .jpg or .png.) This enables the file to be loaded into memory by the native file system
or embedded into the code without having to use the file system within the IFR library.

@param buffer the #IFR_BUFFER_HANDLE containing the image data
@param preferred_format the prefered format for the resulting image. see #ifr_LoadImage3
@param time The @ref time the image was created
@param creationdata User supplied creation data.
@ingroup images

@rethandle{IFR_IMAGE_HANDLE}
*/
IFACEAPI IFR_IMAGE_HANDLE ifr_LoadImageFromBuffer2(IFR_BUFFER_HANDLE buffer, IFR_IMAGE_FORMAT preferred_format, IFR_TIME time, const char *creationdata);

/**
Creates an in-memory representation of an #IFR_IMAGE_HANDLE

The output format depends on the extension of the file, normally '.png' or '.jpg'
@note use '.png' for lossless
Returns an #IFR_BUFFER_HANDLE (which needs to be freed with #ifr_Free)
Use the buffer functions to get length, data pointer for writing to disk etc.
@handleparam{IFR_IMAGE_HANDLE,imageHandle}
@param ext A string describing the output format as a file extension (e.g. '.png')
@param preferred_format the prefered colourspace format for the resulting image for default #IFR_DEFAULT_FORMAT to leave it alone 

@rethandle{IFR_BUFFER_HANDLE}
@ingroup images
*/
IFACEAPI IFR_BUFFER_HANDLE ifr_SaveImageToMemory(IFR_IMAGE_HANDLE imageHandle, const char *ext, IFR_IMAGE_FORMAT preferred_format);

/**
@deprecated ifr_SaveImageToMemory
Creates an in-memory representation of an #IFR_IMAGE_HANDLE in a non standard lossless format.

Returns an IFRBuffer (which needs to be freed with #ifr_Free)
Use buffer functions to get length, data pointer for writing to disk etc.

@handleparam{IFR_IMAGE_HANDLE,imageHandle}
@param compression Compression type applied (if any.)
@rethandle{IFR_BUFFER_HANDLE}
@ingroup images

*/
IFACEAPI IFR_BUFFER_HANDLE ifr_SerialiseImage(IFR_IMAGE_HANDLE imageHandle, IFR_IMAGE_COMPRESSION compression);

/**
Deserialises an image serialsied by the function #ifr_SerialiseImage
@handleparam{IFR_BUFFER_HANDLE,bufferHandle}
@rethandle{IFR_IMAGE_HANDLE}
*/
IFACEAPI IFR_IMAGE_HANDLE ifr_DeserialiseImage(IFR_BUFFER_HANDLE bufferHandle);

/**
Saves an image to disk in whichever format is deduced from the file extension supplied

@handleparam{IFR_IMAGE_HANDLE,imageHandle}

@param	location   	The location on the file system to save to.
@param preferred_format the prefered format for the resulting image. #IFR_IMAGE_FORMAT, use #IFR_DEFAULT_FORMAT to save as is

@ifr_return
@ingroup images

*/
IFACEAPI IFR_RETURN ifr_SaveImage(IFR_IMAGE_HANDLE imageHandle, const char *location, IFR_IMAGE_FORMAT preferred_format);

/**
returns the Region of interest rectangle of the image.

A region of interest is an area of an image that will be processed further.
Pixels outside of the region of interest will not be processed.

Pass in the address of a #IFR_RECT that will be filled in with the region of interest.

@handleparam{IFR_IMAGE_HANDLE,imageHandle}
@param rect A pointer to a #IFR_RECT that gets filled in with the result.
@ingroup images

@ifr_return
*/
IFACEAPI IFR_RETURN ifr_GetImageROI(const IFR_IMAGE_HANDLE imageHandle, IFR_RECT *rect);


/**
Returns a handle to the original full image referenced by an image with an ROI set, this does not copy the image.
@handleparam{IFR_IMAGE_HANDLE,imageHandle}
@outhandleparam{IFR_IMAGE_HANDLE, imageDest}

@ingroup images

@ifr_return
*/
IFACEAPI IFR_RETURN ifr_ImageGetFullImage(IFR_IMAGE_HANDLE imageHandle, IFR_IMAGE_HANDLE *imageDest);

/**
returns a new image which is a new reference to the supplied image with the region of interest set to the rectange
This acts identically to a normal image cropped using #ifr_ImageCrop except no pixels were harmed,
it is possible to get the original image back by calling #ifr_ImageGetFullImage
This does not copy the image.

@handleparam{IFR_IMAGE_HANDLE,imageHandle}

@param  rect                The rectangle.
@outhandleparam{IFR_IMAGE_HANDLE, imageDest}
@ingroup images

@ifr_return
*/
IFACEAPI IFR_RETURN ifr_ImageGetROIImage(IFR_IMAGE_HANDLE imageHandle, const IFR_RECT *rect, IFR_IMAGE_HANDLE *imageDest);

/**
Creates a crop of an image with a rotation around a supplied centre point
@handleparam{IFR_IMAGE_HANDLE,imageHandle}
@param  centrePoint         the centrepoint of the new image
@param  angle               The angle in degrees to rotate the image.
@param size                 The witdth of the cropping square
@rethandle{IFR_IMAGE_HANDLE}
@ingroup images

*/
IFACEAPI IFR_IMAGE_HANDLE ifr_ImageGetCroppedRotatedImage(IFR_IMAGE_HANDLE imageHandle, const IFR_POINT *centrePoint, float angle, uint32_t size);

/**
Creates a normalised colourmap of a grayscale image( IFR_GRAYSCALE or IFR_GRAY16)
Returns the image in BGRA format.
@handleparam{IFR_IMAGE_HANDLE,imageHandle}
@rethandle{IFR_IMAGE_HANDLE}
@ingroup images

*/
IFACEAPI IFR_IMAGE_HANDLE ifr_ImageNormaliseToColourMap(IFR_IMAGE_HANDLE imageHandle);


/**
@deprecated use #ifr_ImageCrop2
Returns a new image which is a copy of the image supplied cropped to the rectangle given.
This does copy the image and the original image is not referenced. if the rectangle is
not supplied it uses the set Region of interest as the cropping rect;

@handleparam{IFR_IMAGE_HANDLE,imageHandle}
@param [in] rect         The rectangle to crop. @invalid_is_undefined
@outhandleparam{IFR_IMAGE_HANDLE, imageDest}


@ifr_return
@ingroup images

*/
DEPRECATED_IFACEAPI IFR_RETURN ifr_ImageCrop(IFR_IMAGE_HANDLE imageHandle, const IFR_RECT *rect, IFR_IMAGE_HANDLE *imageDest);

/**
Returns a new image which is a copy of the image supplied cropped to the rectangle given.
This does copy the image and the original image is not referenced. If the rectangle is
not supplied it uses the set Region of interest as the cropping rect;

@handleparam{IFR_IMAGE_HANDLE,imageHandle}
@param [in] rect         The rectangle to crop. @invalid_is_undefined

@rethandle{IFR_IMAGE_HANDLE}
@ingroup images

*/
IFACEAPI IFR_IMAGE_HANDLE ifr_ImageCrop2(IFR_IMAGE_HANDLE imageHandle, const IFR_RECT *rect);

/**
Returns a new image which is a crop of the maximum bounding box of a face, given the eye locations.
This does copy the image and the original image is not referenced.
Does not perform the required rotation but leaves enough space for this to happen.
Also modifies the IFR_EYES to be relative to the new image.
Extremely fast implementation that can be performed prior to processing.

@handleparam{IFR_IMAGE_HANDLE,imageHandle}
@param [in,out] eyes     The eyes of the face to crop to and returns eyes relative to cropped image. @invalid_is_undefined

@rethandle{IFR_IMAGE_HANDLE}
@ingroup images
*/
IFACEAPI IFR_IMAGE_HANDLE ifr_ImageCropToEyeBounds(IFR_IMAGE_HANDLE imageHandle, IFR_EYES* eyes);

/**
@deprecated use #ifr_ImageResize2

Returns a copy of the image. resized to the new width and height

@handleparam{IFR_IMAGE_HANDLE,imageHandle}
@param  width               The target width.
@param  height              The target height.
@outhandleparam{IFR_IMAGE_HANDLE, imageDest}


@ifr_return
@ingroup images

*/
DEPRECATED_IFACEAPI IFR_RETURN ifr_ImageResize(IFR_IMAGE_HANDLE imageHandle, size_t width, size_t height, IFR_IMAGE_HANDLE *imageDest);


/**
Returns a copy of the image. resized to the new width and height

@handleparam{IFR_IMAGE_HANDLE,imageHandle}
@param  width               The target width.
@param  height              The target height.

@rethandle{IFR_IMAGE_HANDLE}
@ingroup images

*/
IFACEAPI IFR_IMAGE_HANDLE ifr_ImageResize2(IFR_IMAGE_HANDLE imageHandle, size_t width, size_t height);



/*
Make a copy of an #IFR_IMAGE_HANDLE
This is a deep copy, with an option colourspace conversion

@handleparam{IFR_IMAGE_HANDLE,imageHandle}
@param format New image format, use #IFR_DEFAULT_FORMAT to keep the original colour format

@rethandle{IFR_IMAGE_HANDLE}
@ingroup images

**/
IFACEAPI IFR_IMAGE_HANDLE ifr_ImageCopy(IFR_IMAGE_HANDLE imageHandle, IFR_IMAGE_FORMAT format);

/**
Create a face object from an image.
This function should only be used if the image is already the correct size and shape for a face. use the #ifr_CreateFaceFromEyes, or #ifr_CreateFaceFromDetection otherwise

@handleparam{IFR_IMAGE_HANDLE,imageHandle}
@param flags Specify any additional processing the face image receives before the face is created, see #IFR_CREATE_FACE_FLAGS
(The input image remains unchanged.)

@rethandle{IFR_FACE_HANDLE}
@ingroup faces
*/
IFACEAPI IFR_FACE_HANDLE ifr_CreateFace(IFR_IMAGE_HANDLE imageHandle, IFR_CREATE_FACE_FLAGS flags DEFAULTPARAM);

/**
Create a face object from an image, using supplied eyelocations

@param image An image handle to create the face from, this image is expected to be larger than the image captured for the resultant face as it may be rotated and scaled to fit the required eyes.
@param eyes a pointer to a valid set of eyelocations within the borders of the image. see #IFR_EYES
@param flags Specify any additional processing the face image receives before the face is created, see #IFR_CREATE_FACE_FLAGS
(The input image remains unchanged.)

@rethandle{IFR_FACE_HANDLE}
@ingroup faces
*/
IFACEAPI IFR_FACE_HANDLE ifr_CreateFaceFromEyes(IFR_EYES const *eyes, IFR_IMAGE_HANDLE image, IFR_CREATE_FACE_FLAGS flags DEFAULTPARAM);

/**
Create a face object from an image, using the results from a facedetection.
This can be more effiecient that useing #ifr_CreateFaceFromEyes if you have used the internal detector, as some of the needed face features may have already been calculated

@param image An image handle to create the face from, this image is expected to be larger than the image captured for the resultant face as it may be rotated and scaled to fit the required eyes.
@param det a pointer to a valid face detection result see #ifr_DetectFacesInImage2, #IFR_DETECTORRESULT
@param flags Specify any additional processing the face image receives before the face is created, see #IFR_CREATE_FACE_FLAGS
(The input image remains unchanged.)

@rethandle{IFR_FACE_HANDLE}
@ingroup faces
*/
IFACEAPI IFR_FACE_HANDLE ifr_CreateFaceFromDetection(IFR_DETECTORRESULT const *det, IFR_IMAGE_HANDLE image, IFR_CREATE_FACE_FLAGS flags);


/**
@cond DONTDOXYCOMMENT
Create a face object from an image, assuming the image is a full face, but use labeling to refine eye locations
@warning This is experimental so use caution when using.
The image must already be very close to the required size already, or else the labeling may not work properly

@param image An image handle to create the face with.
@param flags Specify any additional processing the face image receives before the face is created.
(The input image remains unchanged.)

@rethandle{IFR_FACE_HANDLE}
@ingroup faces
IFACEAPI IFR_FACE_HANDLE ifr_CreateFaceByLabeling(IFR_IMAGE_HANDLE image, IFR_CREATE_FACE_FLAGS flags);
@endcond 
*/


/**
Given a set of eye positions, returns the centre point of the face

@param eyelocs A pointer to an #IFR_EYES structure holding the eye positions
@param centrePoint A pointer to an #IFR_POINT structure that gets filled with the centrepoint
@ingroup coords
*/
IFACEAPI void ifr_GetCentrePointFromEyes(IFR_EYES const *eyelocs, IFR_POINT *centrePoint);


/**
Given a set of eye positions, return the distance between them
@param eyelocs A pointer to an #IFR_EYES structure holding the eye positions
@return The distance between the eyes
@ingroup coords
*/
IFACEAPI float ifr_GetEyeDistance(IFR_EYES eyelocs);
/**
Given a pair of points, return the distance between them
@param a A pointer to an #IFR_POINT structure holding first coordinate
@param b A pointer to an #IFR_POINT structure holding second coordinate
@return The distance between the points
@ingroup coords
*/
IFACEAPI float ifr_GetDistance(IFR_POINT a, IFR_POINT b);

/**
Given a set of eye positions, rotate them by a given angle around the centre point of the face

@param originalEyes the #IFR_EYES structure holding the original eye positions
@param RotationInDegrees The rotation angle to rotate the eyes by
@return An IFR_EYES structure that is filled with the rotated eye positions
@ingroup coords

*/
IFACEAPI IFR_EYES ifr_GetRotatedEyes(IFR_EYES originalEyes, float RotationInDegrees);

/**
Rotate a set of eyes around an arbitrary point

@param originalEyes the eyes to be rotated
@param RotationInDegrees The rotation angle in degrees
@param pointToRotateAround the point the eyes will be rotated around
@return An IFR_EYES structure that is filled with the rotated eye positions
@ingroup coords
*/
IFACEAPI IFR_EYES ifr_GetRotatedEyesAroundPoint(IFR_EYES originalEyes, float RotationInDegrees, IFR_POINT pointToRotateAround);

/** Get the centrepoint of a face, given eyelocations
@param eyes the eye locations
@return a point with the centre of the face
@ingroup coords

*/
IFACEAPI IFR_POINT ifr_GetFaceCentreFromEyes(IFR_EYES eyes);
/** Get the angle of rotation of eyes
@param eyes the eye locations
@return the angle of rotation
@ingroup coords

*/
IFACEAPI float ifr_GetEyeRotation(IFR_EYES eyes);


/** calculates Eye coordinates from a size, centrepoint and angle
@param centre the centre of a face
@param size the size of the face (3 times the eye distance)
@param angle the angle of rotation
@return the EYE coordinates
@ingroup coords
*/
IFACEAPI IFR_EYES ifr_GetEyesFromCentre(IFR_POINT centre, uint32_t size, float angle);

/** calculates Eye coordinates from a size, centrepoint and angle
@param eyes the eye locations
@param scalex scale factor in x
@param scaley scale factor in y
@return the EYE coordinates
@ingroup coords
*/
IFACEAPI IFR_EYES ifr_GetScaledEyes(IFR_EYES eyes, float scalex, float scaley);

/** calculates Eye coordinates from a size, centrepoint and angle
@param centre the centre of a face
@param faceBoxSize the size of the face (3 times the eye distance)
@param angle the angle of rotation
@param scalex scale factor in x
@param scaley scale factor in y
@return the EYE coordinates
@ingroup coords
*/
IFACEAPI IFR_EYES ifr_GetScaledEyesFromCentre(IFR_POINT centre, uint32_t faceBoxSize, float angle, float scalex, float scaley);

/**
Returns the unique face ID from a face object

@param FaceHandle A face handle @invalid_is_undefined
@return The unique face ID of the face
@ingroup faces
*/
IFACEAPI IFR_UUID ifr_FaceGetID(IFR_FACE_HANDLE FaceHandle);


/**
Returns the image from a face object
@param FaceHandle The face handle @invalid_is_undefined
@rethandle{IFR_IMAGE_HANDLE}
@ingroup faces
*/
IFACEAPI IFR_IMAGE_HANDLE ifr_FaceGetImage(IFR_FACE_HANDLE FaceHandle);

/**
Returns the depthmap from a face object if it exists
@param FaceHandle The face handle @invalid_is_undefined
@rethandle{IFR_IMAGE_HANDLE}
@ingroup faces
*/
IFACEAPI IFR_IMAGE_HANDLE ifr_FaceGetDepthMap(IFR_FACE_HANDLE FaceHandle);


/**
Returns the face quality from a face object

Face quality returns a float that represents how "good" a face is.
A higher number means a "better" face. A symetrical front facing face with a neutral expression will recieve a high score.
@note a score of 0.002 is considered a very good face, 0.001 is an ok face.
@warning This metric only works if the image in a face object is @b really a face. Images that are not faces may produce metrics that are considered high for a face


@param FaceHandle The face handle @invalid_is_undefined
@return The face quality metric.
@ingroup faces
*/
IFACEAPI float ifr_FaceGetQuality(IFR_FACE_HANDLE FaceHandle);


/**
Returns the face likelihood meaurement from a face object
if > 0 means it is a face.
**/

IFACEAPI float ifr_FaceGetFaceness(IFR_FACE_HANDLE FaceHandle);

/**
Returns the face variance from a face object

Face variance returns a float that attempts to descern if a face image is really a face.
A lower number means the image is more likely to be a face. A symetrical front facing face with a neutral expression will recieve a lower score.
@note a score of  < 0.37 is considered generally to be a face > 0.5 is generally not a face

@param FaceHandle The face handle @invalid_is_undefined
@return The face variance metric.
@ingroup faces
*/
IFACEAPI float ifr_FaceGetVariance(IFR_FACE_HANDLE FaceHandle);

/**
Returns the gender estimate from a face object
This metric is about 90% accurate

The scale runs from -1 to 1.
Anything between about -0.1 and 0.1 should be presumed unknown.
If a persons gender is incorrectly determined once, the algorithm is likely to consistantly get that person incorrect.

value| meaning
-----|--------------------------
-1.0 | 100% confidence of being female
-0.5 | 50%  confidence of being female
0.5  | 50%  confidence of being male
1.0  | 100% confidence of being male

if this returns anything below -2 then an error has occured, check #ifr_GetLastError

@param FaceHandle The face handle
@param algo the algorithm to use
@return The gender estimate.
@ingroup faces

*/
IFACEAPI float ifr_FaceGetGender(IFR_FACE_HANDLE FaceHandle, IFR_ALGORITHM algo);
/** Gets a gender estimate from a list of faces
It is presumed that all faces in the list are of the same person
see #ifr_FaceGetGender for more details
@param flh The face list handle handle
@param algo the algorithm to use
@ingroup faces
*/
IFACEAPI float ifr_FaceListGetGender(IFR_FACELIST_HANDLE flh, IFR_ALGORITHM algo);


/**
Returns the age estimate from a face object
@deprecated It has been determined that this functionality is not currently reliable and should not be used
if this returns anything below -2 then an error has occured, check #ifr_GetLastError

@param FaceHandle The face handle
@param algo the algorithm to use
@return The gender estimate.
@ingroup faces

*/
DEPRECATED_IFACEAPI float ifr_FaceGetAge(IFR_FACE_HANDLE FaceHandle, IFR_ALGORITHM algo);

/**
Returns the spoofing results for a face - this is only available for specific cameras
If spoof detection is not available the #IFR_SPOOF_NOTAVAILABLE flag will be set
If an error occurs the #IFR_SPOOF_NOTAVAILABLE flag will be set, and #ifr_GetLastErrorCode will have an error code.

@param faceHandle The face handle
@return The #IFR_SPOOF_CHECKS structure.
@setslasterror
@ingroup faces
*/

IFACEAPI IFR_SPOOF_CHECKS ifr_FaceGetSpoofs(IFR_FACE_HANDLE faceHandle);


/** 
Gets an age estimate from a list of faces
@deprecated It has been determined that this functionality is not currently reliable and should not be used
It is presumed that all faces in the list are of the same person
see #ifr_FaceGetAge for more details
@ingroup faces
*/
DEPRECATED_IFACEAPI float ifr_FaceListGetAge(IFR_FACELIST_HANDLE flh, IFR_ALGORITHM algo);


/** serialises a facelist to a buffer
@handleparam{IFR_FACELIST_HANDLE,handle}
@param compression a flag to control any image compression to use
@rethandle{IFR_BUFFER_HANDLE}
@ingroup faces*/ 

IFACEAPI IFR_BUFFER_HANDLE ifr_SerialiseFacelist(IFR_FACELIST_HANDLE handle, IFR_IMAGE_COMPRESSION compression);
/** deserialises a facelist from a buffer
@handleparam{IFR_BUFFER_HANDLE,bufferHandle}
@rethandle{IFR_FACELIST_HANDLE}
@ingroup faces*/ 
IFACEAPI IFR_FACELIST_HANDLE ifr_DeserialiseFacelist(IFR_BUFFER_HANDLE bufferHandle);

/** serialises a face to a buffer
@handleparam{IFR_FACE_HANDLE,handle}
@param compression a flag to control any image compression to use
@rethandle{IFR_BUFFER_HANDLE}
@ingroup faces*/ 
IFACEAPI IFR_BUFFER_HANDLE ifr_SerialiseFace(IFR_FACE_HANDLE handle, IFR_IMAGE_COMPRESSION compression);
/** deserialises a face from a buffer
@handleparam{IFR_BUFFER_HANDLE,bufferHandle}
@rethandle{IFR_FACE_HANDLE}
@ingroup faces*/ 
IFACEAPI IFR_FACE_HANDLE ifr_DeserialiseFace(IFR_BUFFER_HANDLE bufferHandle);


/** gets a model from a facelist
@handleparam{IFR_FACELIST_HANDLE,facelistHandle}
@param fsize the feature set to get the model for
@rethandle{IFR_MODELDATA_HANDLE}
@ingroup faces*/

IFACEAPI IFR_MODELDATA_HANDLE ifr_FaceListGetModelData(const IFR_FACELIST_HANDLE facelistHandle, IFR_FEATURESET fsize);

/** gets a model from a face
@handleparam{IFR_FACE_HANDLE,faceHandle}
@param fsize the feature set to get the model for
@rethandle{IFR_MODELDATA_HANDLE}
@ingroup faces*/

IFACEAPI IFR_MODELDATA_HANDLE ifr_FaceGetModelData(const IFR_FACE_HANDLE faceHandle, IFR_FEATURESET fsize);

/** gets the feature set used in a model
@handleparam{IFR_MODELDATA_HANDLE,handle}
@return The Featureset used in the model
@ingroup faces*/
IFACEAPI IFR_FEATURESET ifr_ModelDataGetFeatureSet(IFR_MODELDATA_HANDLE handle);

/** serialises a modeldata to a buffer
@handleparam{IFR_MODELDATA_HANDLE,handle}
@rethandle{IFR_BUFFER_HANDLE}
@ingroup faces*/
IFACEAPI IFR_BUFFER_HANDLE ifr_SerialiseModelData(IFR_MODELDATA_HANDLE handle);
/** deserialises a model data from a buffer
@handleparam{IFR_BUFFER_HANDLE,bufferHandle}
@rethandle{IFR_MODELDATA_HANDLE}
@ingroup faces*/
IFACEAPI IFR_MODELDATA_HANDLE ifr_DeserialiseModelData(IFR_BUFFER_HANDLE bufferHandle);

/** Returns raw model data
@handleparam{IFR_MODELDATA_HANDLE,handle}
@rethandle{IFR_FLOATS_HANDLE}
@ingroup faces*/
IFACEAPI IFR_FLOATS_HANDLE ifr_ModelDataGetRaw(IFR_MODELDATA_HANDLE handle);


/**
@brief  get the creation time of the underlying face image
@handleparam{IFR_FACE_HANDLE,handle}
@return An IFR_TIME see @ref time
@ingroup faces
*/
IFACEAPI IFR_TIME ifr_FaceGetUTCCreationTime(IFR_FACE_HANDLE handle);

/**
Creates a copy of an existing face
@deprecated Given a face object is effectivly imutable, and also does lazy model generation, it is unwise to use this, as it may mean models getting generated multiple times
if you need a second handle use #ifr_Duplicate or #ifr_DuplicateFaceHandle 

This function allocates a new face with a copy of an existing faces data. The
The face created @b must be freed with the #ifr_Free function.

@handleparam{IFR_FACE_HANDLE,src}
@outhandleparam{IFR_FACE_HANDLE, dest}


@ifr_return
@ingroup faces
*/
DEPRECATED_IFACEAPI IFR_RETURN ifr_CopyFace(const IFR_FACE_HANDLE src, IFR_FACE_HANDLE *dest);

/**
Compares 2 faces and returns the distance between them.

The lower the distance the closer the faces are.
Typically the range is from just over 1 (most likely not a match) to 0 (perfect match).
A good match is typically between 0.5 and 0.8.

@handleparam{IFR_FACE_HANDLE,face1}
@handleparam{IFR_FACE_HANDLE,face2}
@param [in]	    algorithm	High, Medium or Low algorythm to use

@return The distance between the faces.
        Returns -100 if there's an error, call ifr_GetLastErrorCode to get the error details.
        @ingroup faces
*/
IFACEAPI double ifr_CompareFaces(const IFR_FACE_HANDLE face1, const IFR_FACE_HANDLE face2, IFR_ALGORITHM algorithm);

/**
Compares 2 face lists and returns the distance between them, averaged over every face

The lower the distance the closer the faces are.
Typically the range is from just over 1 (most likely not a match) to 0 (perfect match).
A good match is typically between 0.5 and 0.8.

@handleparam{IFR_FACELIST_HANDLE,facelistHandle1}
@handleparam{IFR_FACELIST_HANDLE,facelistHandle2}
@param [in]	algorithm	High, Medium or Low algorithm to use

@return The distance between the facelists
        Returns -100 if there's an error, call ifr_GetLastErrorCode to get the error details.
        @ingroup faces
*/
IFACEAPI double ifr_CompareFaceLists(const IFR_FACELIST_HANDLE facelistHandle1, const IFR_FACELIST_HANDLE facelistHandle2, IFR_ALGORITHM algorithm);

/**
Set the name of a person object.
@handleparam{IFR_PERSON_HANDLE,person}
@param name	A pointer to a C string containing the persons name.
@ifr_return
@ingroup person
*/
IFACEAPI IFR_RETURN ifr_PersonSetName(IFR_PERSON_HANDLE person, const char *name);

/**
@brief  Adds a tag to a person, @note The person needs to be saved for it to have effect on the database

@handleparam{IFR_PERSON_HANDLE,person}
@param  tag     The tag.
@ifr_return
@ingroup person

*/
IFACEAPI IFR_RETURN ifr_PersonAddTag(IFR_PERSON_HANDLE person, const char *tag);

/**
@brief  Removes a tag from a person. @note The person needs to be saved for it to have effect on the database
@handleparam{IFR_PERSON_HANDLE,person}
@param  tag     The tag.
@ifr_return
@ingroup person
*/
IFACEAPI IFR_RETURN ifr_PersonRemoveTag(IFR_PERSON_HANDLE person, const char *tag);

/**
@brief  Gets the number of tags that are attached to the person
@handleparam{IFR_PERSON_HANDLE,person}
@return The number of tags in a person.
@ingroup person
*/
IFACEAPI size_t ifr_PersonGetNumTags(IFR_PERSON_HANDLE person);

/**
@brief  Gets the tag at specified index,
@handleparam{IFR_PERSON_HANDLE,person}
@param  index   Zero-based index of the tag.
@return null if it fails, otherwise a char*.
@setslasterror
@ingroup person
*/
IFACEAPI const char *ifr_PersonGetTag(IFR_PERSON_HANDLE person, size_t index);

/**
@brief  test to see if a person object already has a tag,
@handleparam{IFR_PERSON_HANDLE,person}
@param  tag The tag.
@return >0 if true, otherwise 0.
@setslasterror
@ingroup person
*/
IFACEAPI int ifr_PersonHasTag(IFR_PERSON_HANDLE person, const char *tag);

/** Returns all known tags in the database
@deprecated use #ifr_GetKnownTags2
@handleparam{IFR_CONTEXT_HANDLE,context}
@outhandleparam{IFR_STRINGS_HANDLE, tags}
@callbackparam{IFR_StringsCompletionRoutine,callback}
@userparam
@deferred_return
@ingroup facedb
*/ 
DEPRECATED_IFACEAPI IFR_RETURN ifr_GetKnownTags(IFR_CONTEXT_HANDLE context, IFR_STRINGS_HANDLE *tags, IFR_StringsCompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);

/** Returns all known tags in the database
@handleparam{IFR_CONTEXT_HANDLE,context}
@callbackparam{IFR_StringsCompletionRoutine,callback}
@userparam
@deferred_rethandle{IFR_STRINGS_HANDLE}
@ingroup facedb
*/ 
IFACEAPI IFR_STRINGS_HANDLE ifr_GetKnownTags2(IFR_CONTEXT_HANDLE context, IFR_StringsCompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);

/** 
@getitem{string,IFR_STRINGS_HANDLE,handle}
@sa #ifr_GetNumStrings
*/
IFACEAPI const char *ifr_GetString(IFR_STRINGS_HANDLE handle, size_t index);
/** 
@getcount{string,IFR_STRINGS_HANDLE,handle}
@sa #ifr_GetString
*/
IFACEAPI size_t ifr_GetNumStrings(IFR_STRINGS_HANDLE handle);

/** 
@getitem{int32_t,IFR_INTS_HANDLE,handle}
@sa #ifr_GetNumInts
*/
IFACEAPI int32_t ifr_GetInt(IFR_INTS_HANDLE handle, size_t index);
/** 
@getcount{int32_t,IFR_INTS_HANDLE,handle}
@sa ifr_GetInt
*/
IFACEAPI size_t ifr_GetNumInts(IFR_INTS_HANDLE handle);
/**
@getdata{int,IFR_FLOATS_HANDLE,handle}
@sa ifr_GetInt
*/
IFACEAPI const int32_t * ifr_GetIntData(IFR_INTS_HANDLE handle);


/**
@getitem{float,IFR_FLOATS_HANDLE,handle}
@sa #ifr_GetNumFloats
*/
IFACEAPI float ifr_GetFloat(IFR_FLOATS_HANDLE handle, size_t index);
/**
@getcount{float,IFR_FLOATS_HANDLE,handle}
@sa ifr_GetFloat
*/
IFACEAPI size_t ifr_GetNumFloats(IFR_FLOATS_HANDLE handle);
/**
@getdata{float,IFR_FLOATS_HANDLE,handle}
@sa ifr_GetFloat
*/
IFACEAPI const float * ifr_GetFloatData(IFR_FLOATS_HANDLE handle);

/**
Get the unique ID of a person.
@handleparam{IFR_PERSON_HANDLE,person}
@return The unique ID of this person
@ingroup person
*/
IFACEAPI IFR_UUID ifr_PersonGetID(IFR_PERSON_HANDLE person);

/**
Get the name of a person.
@handleparam{IFR_PERSON_HANDLE,person}
@return A C string containing the name. @objectlocal
@ingroup person
*/
IFACEAPI const char *ifr_PersonGetName(IFR_PERSON_HANDLE person);

/**
Adds a face to a face list
@handleparam{IFR_FACELIST_HANDLE,facelist}
@handleparam{IFR_FACE_HANDLE,face}
@ifr_return
@ingroup faces
*/
IFACEAPI IFR_RETURN ifr_AddToFaceList(IFR_FACELIST_HANDLE facelist, IFR_FACE_HANDLE face);

/**
@brief  Adds a face list keeping best "NumToKeep" quality faces see #ifr_FaceGetQuality
This function is useful if you are tracking a face accross multiple video frames and would like to keep the ones best suitable for face recognition

@handleparam{IFR_FACELIST_HANDLE, facelist}
@handleparam{IFR_FACE_HANDLE,face}
@ifr_return
@param  NumToKeep   Max Number of faces to  keep in the FaceList.

@return #IFR_SUCCESS, if FaceList was modified, #IFR_FALSE if it was not, otherwise an error code from #IFR_RETURN
@ingroup faces
 
 */
IFACEAPI IFR_RETURN ifr_AddToFaceListKeepingBestQuality(IFR_FACELIST_HANDLE facelist, IFR_FACE_HANDLE face, size_t NumToKeep);

/**
Adds contents of one facelist to another.
Takes each face from srcFaceList and appends them to destFaceList.
@handleparam{IFR_FACELIST_HANDLE ,destFaceList, the destination facelist}
@handleparam{IFR_FACE_HANDLE,srcFaceList, the source facelist}
@ifr_return
@ingroup faces
*/
IFACEAPI IFR_RETURN ifr_AddFaceListToFaceList(IFR_FACELIST_HANDLE destFaceList, IFR_FACELIST_HANDLE srcFaceList);

/**
Clear a facelist of all it's faces.
@handleparam{IFR_FACELIST_HANDLE ,faceList}
@ifr_return
@ingroup faces
*/
IFACEAPI IFR_RETURN ifr_FaceListClear(IFR_FACELIST_HANDLE faceList);

/**
Removes specified face from a facelist;
@handleparam{IFR_FACELIST_HANDLE ,faceListHandle}
@handleparam{IFR_FACE_HANDLE ,faceHandle}
@ifr_return
@ingroup faces
*/
IFACEAPI IFR_RETURN ifr_FaceListRemoveFace(IFR_FACELIST_HANDLE faceListHandle, IFR_FACE_HANDLE faceHandle);

/**
@brief  Copies a face list, replacing anything in the source facelist
Takes each face from srcFaceList and appends them to destFaceList.
@handleparam{IFR_FACELIST_HANDLE ,destFaceList, the destination facelist}
@handleparam{IFR_FACE_HANDLE,srcFaceList, the source facelist}
@ifr_return
@ingroup faces
*/
IFACEAPI IFR_RETURN ifr_FaceListCopy(IFR_FACELIST_HANDLE destFaceList, IFR_FACELIST_HANDLE srcFaceList);

/**
Remove the poorest quality faces from the face list, keeping only the best \b NumToKeep.
This function will not preserve ordering of faces in the list.
@handleparam{IFR_FACELIST_HANDLE, facelist}
@param  numToKeep   Max Number of faces to  keep in the FaceList.
@return #IFR_SUCCESS, if FaceList was modified, #IFR_FALSE if it was not, otherwise an error code from #IFR_RETURN
@ingroup faces
*/
IFACEAPI IFR_RETURN ifr_RemovePoorestFaces(IFR_FACELIST_HANDLE facelist , int numToKeep);

/**
Removes the face at the specified index.
@handleparam{IFR_FACELIST_HANDLE, facelist}
@param index the index of the face to remove
@ifr_return
@ingroup faces
*/
IFACEAPI IFR_RETURN ifr_RemoveFaceAtIdx(IFR_FACELIST_HANDLE facelist, int index);

/**
Saves a new or updates an existing person in the Database

@handleparam{IFR_CONTEXT_HANDLE,context}
@handleparam{IFR_PERSON_HANDLE, person, The person object to save}
@callbackparam{IFR_CompletionRoutine,callback}
@userparam
@deferred_return
@ingroup facedb
*/
IFACEAPI IFR_RETURN ifr_SavePerson(IFR_CONTEXT_HANDLE context, IFR_PERSON_HANDLE person, IFR_CompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);

/**
Saves or updates multiple people to the database 

@handleparam{IFR_CONTEXT_HANDLE,context}
@param people A pointer to the begining of an array of valid #IFR_PERSON_HANDLE objects. 
@param count The number of objects in the people array.
@callbackparam{IFR_CompletionRoutine,callback}
@userparam
@deferred_return
@ingroup facedb
*/
IFACEAPI IFR_RETURN ifr_SavePeople(IFR_CONTEXT_HANDLE context, IFR_PERSON_HANDLE *people, size_t count, IFR_CompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);

/** Exports a whole person including enrolments, to a buffer
@handleparam{IFR_CONTEXT_HANDLE,context}
@handleparam{IFR_PERSON_HANDLE, person, The person object to save}
@param compression 
@rethandle{IFR_BUFFER_HANDLE}
@ingroup facedb
*/
IFACEAPI IFR_BUFFER_HANDLE ifr_ExportPersonToBuffer(IFR_CONTEXT_HANDLE context, IFR_PERSON_HANDLE person, IFR_IMAGE_COMPRESSION compression);



/** Exports a whole person including enrolments, to a buffer
@handleparam{IFR_CONTEXT_HANDLE,contextHandle}
@handleparam{IFR_UUID, personID, The person id to save}
@callbackparam{IFR_HandleCompletionRoutine,callback}
@userparam
@rethandle{IFR_BUFFER_HANDLE}
@ingroup facedb
*/
IFACEAPI IFR_BUFFER_HANDLE ifr_ExportPersonToBuffer2(IFR_CONTEXT_HANDLE contextHandle, IFR_UUID personID, IFR_HandleCompletionRoutine callback DEFAULTPARAM, void* user DEFAULTPARAM);

/** Exports everything that has occured in the database after ther auditfrom, upto and including the auditTo, into a buffer
@handleparam{IFR_CONTEXT_HANDLE,contextHandle}
@param auditFrom the audit id to get all updates after. ( the updates of this id will not be included )
@param [in,out] auditTo pointer to a valid audit id to get all updates until, if this function is used synchronusly will be set to the latest audit id exported. if it is nullptr or points to -1,  all new updates will be retrieved. ( the updates of this id will be included if it exists )
@callbackparam{IFR_HandleCompletionRoutine,callback}
@userparam
@rethandle{IFR_BUFFER_HANDLE}
@ingroup facedb
*/
IFACEAPI IFR_BUFFER_HANDLE ifr_ExportSyncInfoToBuffer(IFR_CONTEXT_HANDLE contextHandle, int64_t auditFrom, int64_t *auditTo, IFR_HandleCompletionRoutine callback, void* user);


/** Imports a whole person including enrolments, from a buffer
Returns a person handle for the new person
@handleparam{IFR_CONTEXT_HANDLE,contextHandle}
@handleparam{IFR_BUFFER_HANDLE, bufferHandle, The buffer to import from}
@rethandle{IFR_PERSON_HANDLE}
@ingroup facedb
*/
IFACEAPI IFR_PERSON_HANDLE ifr_ImportPersonFromBuffer(IFR_CONTEXT_HANDLE contextHandle, IFR_BUFFER_HANDLE bufferHandle);
IFACEAPI  IFR_RETURN ifr_ImportSyncFromBuffer(IFR_CONTEXT_HANDLE contextHandle, IFR_BUFFER_HANDLE bufferHandle, IFR_CompletionRoutine callback DEFAULTPARAM, void * user DEFAULTPARAM);


/**
Deletes a person from the database, includes dropping all features.
@handleparam{IFR_CONTEXT_HANDLE,context}
@param personId the #IFR_UUID of the person to delete
@callbackparam{IFR_CompletionRoutine,callback}
@userparam
@deferred_return
@ingroup facedb
*/
IFACEAPI IFR_RETURN ifr_DeletePerson(IFR_CONTEXT_HANDLE context, IFR_UUID personId, IFR_CompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);

/**
Deletes an enrolment from the database, includes dropping all faces and features associated.
@handleparam{IFR_CONTEXT_HANDLE,context}
@param enrolmentId the #IFR_UUID of the person to delete
@callbackparam{IFR_CompletionRoutine,callback}
@userparam
@deferred_return
@ingroup facedb
*/
IFACEAPI IFR_RETURN ifr_DeleteEnrolment(IFR_CONTEXT_HANDLE context, IFR_UUID enrolmentId, IFR_CompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);

/**
Deletes an face from the database, includes dropping features associated.

@handleparam{IFR_CONTEXT_HANDLE,context}
@param faceId the #IFR_UUID of the person to delete
@callbackparam{IFR_CompletionRoutine,callback}
@userparam
@deferred_return
@ingroup facedb
*/

IFACEAPI IFR_RETURN ifr_DeleteFace(IFR_CONTEXT_HANDLE context, IFR_UUID faceId, IFR_CompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);

/**
Load a person from the database.
@deprecated use #ifr_LoadPerson2

The callback and person arguments are mutually exclusive: one of them must be null.
If not providing a callback the Person Handle will initialized with the resulting person if any from the search.

@handleparam{IFR_CONTEXT_HANDLE,context}
@param personId  	The unique ID of the person to load.
@outhandleparam{IFR_PERSON_HANDLE, personHandlePointer}
@callbackparam{IFR_PersonCompletionRoutine,callback}
@userparam
@deferred_return
@ingroup facedb
*/
DEPRECATED_IFACEAPI IFR_RETURN ifr_LoadPerson(IFR_CONTEXT_HANDLE context, IFR_UUID personId, IFR_PERSON_HANDLE *personHandlePointer, IFR_PersonCompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);

/**
Load a person from the database.
@handleparam{IFR_CONTEXT_HANDLE,context}
@param personId  	The unique ID of the person to load.
@callbackparam{IFR_PersonCompletionRoutine,callback}
@userparam
@deferred_rethandle{IFR_PERSON_HANDLE}
@ingroup facedb
*/
IFACEAPI IFR_PERSON_HANDLE ifr_LoadPerson2(IFR_CONTEXT_HANDLE context, IFR_UUID personId, IFR_PersonCompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);




/**
Load a Face from the database.
@deprecated use ifr_LoadFace2 with an IFR_FACE_UUID type instead
@handleparam{IFR_CONTEXT_HANDLE,context}
@param id  	The unique ID of object to load a face for.
@outhandleparam{IFR_FACE_HANDLE, face}
@callbackparam{IFR_FaceCompletionRoutine,callback}
@userparam
@deferred_return
@ingroup facedb
*/
IFACEAPI IFR_RETURN ifr_LoadFace(IFR_CONTEXT_HANDLE context, IFR_UUID id, IFR_FACE_HANDLE *face, IFR_FaceCompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);

/**
Load a Face from the database.
This will load a face for either a person (the first or canonical fac in the db), and enrolment (the first face in the enrolment), or a face (the specified face), depending on the value of uuidType supplied
@handleparam{IFR_CONTEXT_HANDLE,context}
@param id  	The unique ID of object to load a face for.
@param uuidType The type of uuid to expect. either #IFR_PERSON_UUID, #IFR_ENROLMENT_UUID, #IFR_FACE_UUID
@callbackparam{IFR_FaceCompletionRoutine,callback}
@userparam
@deferred_rethandle{IFR_FACE_HANDLE}
@ingroup facedb
*/
IFACEAPI IFR_FACE_HANDLE ifr_LoadFace2(IFR_CONTEXT_HANDLE context, IFR_UUID id, IFR_UUID_TYPE uuidType, IFR_FaceCompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);

/**
Load a set of faces face from the database based on person ID.
@deprecated use #ifr_LoadFaceList2
The callback and faces arguments are mutually exclusive: one of them must be null.
Callback function when not null must implement #IFR_FaceCompletionRoutine

@handleparam{IFR_CONTEXT_HANDLE,context}
@param personId	the id of the face to load
@outhandleparam{IFR_FACELIST_HANDLE, faces}
@callbackparam{IFR_FaceListCompletionRoutine,callback}

@userparam
@deferred_return
@ingroup facedb
*/
DEPRECATED_IFACEAPI IFR_RETURN ifr_LoadFaceList(IFR_CONTEXT_HANDLE context, IFR_UUID personId, IFR_FACELIST_HANDLE *faces, IFR_FaceListCompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);

/**
Load a set of faces face from the database based on enrolment ID.
@deprecated use #ifr_LoadFaceList2
The callback and faces arguments are mutually exclusive: one of them must be null.
Callback function when not null must implement #IFR_FaceCompletionRoutine

@handleparam{IFR_CONTEXT_HANDLE,context}
@param enrolmentId	the id of the enrolment to load
@outhandleparam{IFR_FACELIST_HANDLE, faces}
@callbackparam{IFR_FaceListCompletionRoutine,callback}
@userparam
@deferred_return
@ingroup facedb
*/
DEPRECATED_IFACEAPI IFR_RETURN ifr_LoadEnrolment(IFR_CONTEXT_HANDLE context, IFR_UUID enrolmentId, IFR_FACELIST_HANDLE *faces, IFR_FaceListCompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);


/**
Load a set of faces face from the database based on ID.
Like #ifr_LoadFace2, this can accept multiple id types, when supplied an IFR_PERSON_UUID it will load all faces for that person, when supplied an IFR_ENROLMENT_UUID it will load all faces for that enrolment

@handleparam{IFR_CONTEXT_HANDLE,context}
@param id  	The unique ID of object to load a facelist for.
@param uuidType The type of uuid to expect. either #IFR_PERSON_UUID or #IFR_ENROLMENT_UUID
@callbackparam{IFR_FaceListCompletionRoutine,callback}
@userparam
@deferred_rethandle{IFR_FACELIST_HANDLE}
@ingroup facedb
*/

IFACEAPI IFR_FACELIST_HANDLE ifr_LoadFaceList2(IFR_CONTEXT_HANDLE context, IFR_UUID id,IFR_UUID_TYPE uuidType, IFR_FaceListCompletionRoutine callback DEFAULTPARAM, void * user  DEFAULTPARAM);

/**
Load a set of FaceIDS from the database given an enrolmentID
@deprecated see #ifr_GetEnrolmentFaceIds2
The callback and results arguments are mutually exclusive: one of them must be null.
Callback function when not null must implement #IFR_ResultIdsCompletionRoutine
any returned handle must be free when finished with

@handleparam{IFR_CONTEXT_HANDLE,context}
@param enrolmentId	the id of the enrolment to load
@outhandleparam{IFR_RESULTIDS_HANDLE, faces}
@callbackparam{IFR_ResultIdsCompletionRoutine,callback}
@userparam
@deferred_return
@ingroup facedb
*/
IFACEAPI IFR_RETURN ifr_GetEnrolmentFaceIds(IFR_CONTEXT_HANDLE context, IFR_UUID enrolmentId, IFR_RESULTIDS_HANDLE *faces, IFR_ResultIdsCompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);
/**
Load a set of FaceIDS from the database given an enrolmentID

@handleparam{IFR_CONTEXT_HANDLE,context}
@param enrolmentId	the id of the enrolment to load
@callbackparam{IFR_ResultIdsCompletionRoutine,callback}
@userparam
@deferred_rethandle{IFR_RESULTIDS_HANDLE}
@ingroup facedb
*/
IFACEAPI IFR_RESULTIDS_HANDLE ifr_GetEnrolmentFaceIds2(IFR_CONTEXT_HANDLE context, IFR_UUID enrolmentId, IFR_ResultIdsCompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);




/**
Gets List of features required to be stored in the database
cast the Ints returned to #IFR_FEATURESET enum

@handleparam{IFR_CONTEXT_HANDLE,context}
@callbackparam{IFR_HandleCompletionRoutine,callback}
@userparam
@deferred_rethandle{IFR_INTS_HANDLE}
@ingroup facedb
*/
IFACEAPI IFR_INTS_HANDLE ifr_GetDbFeatures(IFR_CONTEXT_HANDLE context, IFR_HandleCompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);


/**
Sets List of required features for the database.
All new enrolments will enroil with all of these features. 
ifr_RebuildDb needs to be called to generate any missing models.
searches will not include results for models not generated until this is completed

@handleparam{IFR_CONTEXT_HANDLE,context}
@param features array of features wanted in the database
@param numFeatures the size of the features array
@callbackparam{IFR_CompletionRoutine,callback}
@userparam
@deferred_return
@ingroup facedb
*/

IFACEAPI IFR_RETURN ifr_SetDbFeatures(IFR_CONTEXT_HANDLE context, IFR_FEATURESET * features, size_t numFeatures,IFR_CompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);


/**
Regenerates all missing models in the database, and removes non required models
see #ifr_SetDbFeatures for information on changing required models

@handleparam{IFR_CONTEXT_HANDLE,context}
@callbackparam{IFR_ProgressRoutine,callback}
@callbackhandleparam
@deferred_return
@ingroup facedb
*/
IFACEAPI IFR_RETURN ifr_GenerateModels(IFR_CONTEXT_HANDLE context, IFR_ProgressRoutine2 callback, IFR_CALLBACK_HANDLE cbHandle);


/**
Finds people by name. Populates results with people in the database whose name matches the search string.
@deprecated using #ifr_GetPeopleIds will produce the same result, and is much more configurable
@code
IFR_CONTEXT_HANDLE ctx = ...;
IFR_RESULTIDS_HANDLE reshandle = NULL;

ifr_FindPersonByName(ctx, "John", &reshandle,NULL,NULL);
@endcode
Is equivalent to 

@code
IFR_CONTEXT_HANDLE ctx = ...;
IFR_RESULTIDS_HANDLE reshandle = ifr_GetPeopleIds(ctx,ifr_GenerateNullUUID(),0,IFR_FWD,"John", NULL,NULL,NULL);
@endcode

The callback and results arguments are mutually exclusive: one of them must be null.

@handleparam{IFR_CONTEXT_HANDLE,context}
@param name		The C String name to search on.
@outhandleparam{IFR_RESULTIDS_HANDLE, results}
@callbackparam{IFR_ResultIdsCompletionRoutine,callback}
@userparam
@deferred_return
@ingroup facedb
*/
IFACEAPI IFR_RETURN ifr_FindPersonByName(IFR_CONTEXT_HANDLE context, const char *name, IFR_RESULTIDS_HANDLE *results, IFR_ResultIdsCompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);

/**
Gets a list of people IDS matching the filters.

@handleparam{IFR_CONTEXT_HANDLE,context}
@param startId		The start identifier for the search to continue from ( use ifr_GenerateNullUUID() for a default start id, (NullUUID in modern c++)).
@param count		Number of ids to return. ( 0 ) to return as many as are available
@param dir      	Direction for search to look from startId can be #IFR_FWD, #IFR_BKD
@param filter       filter for name filtering use % as wildcards, use NULL for no name filtering
@handleparam{IFR_TAG_EXPRESSION_HANDLE,tagExpr, A tag expression to filter the results by}
@callbackparam{IFR_ResultIdsCompletionRoutine,callback}
@userparam
@deferred_rethandle{IFR_RESULTIDS_HANDLE}
@ingroup facedb
*/

IFACEAPI IFR_RESULTIDS_HANDLE ifr_GetPeopleIds(IFR_CONTEXT_HANDLE context, IFR_UUID startId, int64_t count, IFR_DIRECTION dir, const char *filter, IFR_TAG_EXPRESSION_HANDLE tagExpr, IFR_ResultIdsCompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);
/**
Gets a list of people IDS matching the filters. using ofsets into results.

@handleparam{IFR_CONTEXT_HANDLE,context}
@param offset		The  offset into the total result set to continue from ( use 0 to start at the beginning/end).
@param count		Number of ids to return. ( 0 ) to return as many as are available
@param dir      	Direction for search to look from startId can be #IFR_FWD, #IFR_BKD
@param filter       filter for name filtering use % as wildcards, use NULL for no name filtering
@handleparam{IFR_TAG_EXPRESSION_HANDLE,tagExpr, A tag expression to filter the results by}
@callbackparam{IFR_ResultIdsCompletionRoutine,callback}
@userparam
@deferred_rethandle{IFR_RESULTIDS_HANDLE}
@ingroup facedb
*/

IFACEAPI IFR_RESULTIDS_HANDLE ifr_GetPeopleIdsByOffset(IFR_CONTEXT_HANDLE context, int64_t offset, int64_t count, IFR_DIRECTION dir, const char *filter, IFR_TAG_EXPRESSION_HANDLE tagExpr, IFR_ResultIdsCompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);

/** Returns the offset into a #ifr_GetPeopleIdsByOffset offset query a person ID would appear
@handleparam{IFR_CONTEXT_HANDLE,context}
@param personId     The Id of a person
@param dir      	Direction for search to look from startId can be #IFR_FWD, #IFR_BKD
@param filter       filter for name filtering use % as wildcards, use NULL for no name filtering
@handleparam{IFR_TAG_EXPRESSION_HANDLE,tagExpr, A tag expression to filter the results by}
@callbackparam{IFR_ResultIdsCompletionRoutine,callback}
@userparam
@return the offset
@ingroup facedb
*/
IFACEAPI int64_t ifr_GetPersonOffset(IFR_CONTEXT_HANDLE context, IFR_UUID personId, IFR_DIRECTION dir, const char *filter, IFR_TAG_EXPRESSION_HANDLE tagExpr, IFR_Int64CompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);


/**
Given a personID gets a list of all associated EnrolmentIds
@deprecated use #ifr_GetEnrolmentIds2.

The callback and results arguments are mutually exclusive: one of them must be null.

@handleparam{IFR_CONTEXT_HANDLE,context}
@param personId     The Id of a person
@outhandleparam{IFR_RESULTIDS_HANDLE, results}
@callbackparam{IFR_ResultIdsCompletionRoutine,callback}
@userparam
@deferred_return
@ingroup facedb
*/
IFACEAPI IFR_RETURN ifr_GetEnrolmentIds(IFR_CONTEXT_HANDLE context, IFR_UUID personId, IFR_RESULTIDS_HANDLE *results, IFR_ResultIdsCompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);


/**
Given a personID gets a list of all associated EnrolmentIds
@handleparam{IFR_CONTEXT_HANDLE,context}
@param personId     The Id of a person
@callbackparam{IFR_ResultIdsCompletionRoutine,callback}
@userparam
@deferred_rethandle{IFR_RESULTIDS_HANDLE}
@ingroup facedb
*/
IFACEAPI IFR_RESULTIDS_HANDLE ifr_GetEnrolmentIds2(IFR_CONTEXT_HANDLE context, IFR_UUID personId, IFR_ResultIdsCompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);

/** 
@getitem{IFR_UUID,IFR_RESULTIDS_HANDLE,handle}
@sa ifr_GetResultSize
*/
IFACEAPI IFR_UUID ifr_GetResult(IFR_RESULTIDS_HANDLE handle, size_t index);

/** 
@getcount{IFR_UUID,IFR_RESULTIDS_HANDLE,handle}
@sa ifr_GetResult
*/
IFACEAPI size_t ifr_GetResultSize(IFR_RESULTIDS_HANDLE handle);

/**
Adds a facelist to the database as a single enrolment.
The callback and enrolmentId arguments are mutually exclusive: one of them must be null, or else the function will return an error

@handleparam{IFR_CONTEXT_HANDLE,context}
@param personId		The identifier for the person.
@handleparam{IFR_FACELIST_HANDLE,faces}
@param [out] enrolmentId  A pointer that gets populated with the resultant enrolment UUID.
@callbackparam{IFR_EnrolFaceListCompletionRoutine,callback}
@userparam
@deferred_return
@ingroup facedb

*/
IFACEAPI IFR_RETURN ifr_EnrolFaceList(IFR_CONTEXT_HANDLE context, IFR_UUID personId, IFR_FACELIST_HANDLE faces, IFR_UUID *enrolmentId, IFR_EnrolFaceListCompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);

/**
Adds a facelist to the database as a single enrolment.
The function will return a NullUUID value if it fails or a callback was supplied.

@handleparam{IFR_CONTEXT_HANDLE,context}
@param personId		The identifier for the person.
@handleparam{IFR_FACELIST_HANDLE,faces}
@callbackparam{IFR_UUIDCompletionRoutine,callback}
@userparam
@return a new #IFR_UUID with the enrolment id, or if NullUUID a failure or it was deferred. see #ifr_GetLastErrorCode and #ifr_GetLastError
@ingroup facedb

*/
IFACEAPI IFR_UUID ifr_EnrolFaceList2(IFR_CONTEXT_HANDLE context, IFR_UUID personId, IFR_FACELIST_HANDLE faces, IFR_UUIDCompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);




IFACEAPI IFR_RETURN ifr_EnrolFaceLists(IFR_CONTEXT_HANDLE context, IFR_UUID *personId, IFR_FACELIST_HANDLE *faces, size_t count, IFR_CompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);


/*!@cond DONTDOXYCOMMENT	
	These funtions are intended for verification tasks, they are not considered ready to use.
*/
IFACEAPI IFR_VERIFY_HANDLE ifr_Verify(IFR_FACELIST_HANDLE p, IFR_FACELIST_HANDLE g, IFR_VERIFY_FLAGS flags, IFR_VerifyCompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);
IFACEAPI float ifr_GetVerificationResult(IFR_VERIFY_HANDLE vh, const double threshold);
IFACEAPI const char *ifr_GetVerificationDetails(IFR_VERIFY_HANDLE vh);
IFACEAPI IFR_FLOATS_HANDLE ifr_GetVerificationDistances(IFR_VERIFY_HANDLE vh);

/*!@endcond*/


/**
@deprecated use #ifr_Search2 instead

Search the database for a face

The user should allocate and initialise a serach object (#IFR_SEARCH_HANDLE) then pass this into
this function to perform a search. The search results will be available in the search handle once the
search is complete.

@handleparam{IFR_CONTEXT_HANDLE,context}

@handleparam{IFR_SEARCH_HANDLE,sh,	A handle to the search object to use. The user needs to allocate and populate this object before searching.
The results will be returned in the same structure.}

@callbackparam{IFR_SearchCompletionRoutine,callback}
@userparam
@deferred_return
@ingroup search

*/
DEPRECATED_IFACEAPI IFR_RETURN ifr_Search(IFR_CONTEXT_HANDLE context, IFR_SEARCH_HANDLE sh, IFR_SearchCompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);

/**
Requests cancelling a previously running search
@deprecated use #ifr_Search2 instead


All callbacks will be honoured with a cancelled error, unless the search has already been
completed in which case the cancel will be ignored, and the completed results will be
returned as standard.
If the search has already completed and the cancel is requested, nothing happens.

@handleparam{IFR_SEARCH_HANDLE,search, the search object to cancel.}
@ifr_return
@ingroup search

*/

DEPRECATED_IFACEAPI IFR_RETURN ifr_CancelSearch(IFR_SEARCH_HANDLE search);


/**
Generates a new model using user supplied weights for the #ifr_Search2 algorithm
This is for advanced use only, Imagus will have advised you on how to use/appropriate values to supply.

@param type the feature set to use, see #IFR_FEATURESET
@param weights the weights to use for each region in the feature set.
@param count the numebr of weights supplied.
@rethandle{IFR_MODEL_HANDLE}
@ingroup search

*/
IFACEAPI IFR_MODEL_HANDLE ifr_GenerateModel(IFR_FEATURESET type, const float *weights, size_t count);

/**
Retrieves a pre-defined model for the #ifr_Search2 algorithm.
This model is equivalent to the original #IFR_ALGORITHM_DEFAULT_LOW,#IFR_ALGORITHM_DEFAULT_MED,#IFR_ALGORITHM_DEFAULT_HIGH
@param algorithm the algorithm to get the model for 
@rethandle{IFR_MODEL_HANDLE}
@ingroup search

*/
IFACEAPI IFR_MODEL_HANDLE ifr_Model(IFR_ALGORITHM algorithm);
/**
Retrieves a pre-defined model for the #ifr_Search2 algorithm.
This model get the default model for a feastureset
@param feature the feature to get the model for
@rethandle{IFR_MODEL_HANDLE}
@ingroup search

*/
IFACEAPI IFR_MODEL_HANDLE ifr_DefaultModel(IFR_FEATURESET  feature);


/**
Converts the old style #IFR_ALGORITHM to a #IFR_FEATURESET equivalent
@param algorithm the #IFR_FEATURESET 
@returns IFR_FEATURESET
@ingroup search

*/
IFACEAPI IFR_FEATURESET ifr_FeatureSet(IFR_ALGORITHM algorithm);



/**
Search the database for a face match

@handleparam{IFR_CONTEXT_HANDLE,context}
@handleparam{IFR_FACELIST_HANDLE,faces}
@handleparam{IFR_MODEL_HANDLE, model, The model to use see #ifr_Model and #ifr_GenerateModel}
@param flags #IFR_SEARCH_FLAGS to apply
@param maxResults the maximum number of results to return set to <=0 for max number available
@callbackparam{IFR_Search2CompletionRoutine,callback}
@userparam
@deferred_rethandle{IFR_SEARCH_RESULTS_HANDLE}
@ingroup search

*/
IFACEAPI IFR_SEARCH_RESULTS_HANDLE ifr_Search2(IFR_CONTEXT_HANDLE context,
                                               IFR_FACELIST_HANDLE faces,
                                               IFR_MODEL_HANDLE model,
                                               IFR_SEARCH_FLAGS flags,
                                               int maxResults,
                                               IFR_Search2CompletionRoutine callback DEFAULTPARAM,
                                               void *user DEFAULTPARAM);

/**
Search the database for a face match

@handleparam{IFR_CONTEXT_HANDLE,context}
@handleparam{IFR_MODELDATA_HANDLE,facemodels}
@handleparam{IFR_MODEL_HANDLE, model, The model to use see #ifr_Model and #ifr_GenerateModel}
@param flags #IFR_SEARCH_FLAGS to apply
@param maxResults the maximum number of results to return set to <=0 for max number available
@callbackparam{IFR_Search2CompletionRoutine,callback}
@userparam
@deferred_rethandle{IFR_SEARCH_RESULTS_HANDLE}
@ingroup search

*/
IFACEAPI IFR_SEARCH_RESULTS_HANDLE ifr_SearchModel(IFR_CONTEXT_HANDLE context,
	IFR_MODELDATA_HANDLE facemodels,
	IFR_MODEL_HANDLE model,
	IFR_SEARCH_FLAGS flags,
	int maxResults,
	IFR_Search2CompletionRoutine callback DEFAULTPARAM,
	void *user DEFAULTPARAM);




/** @getcount{int,IFR_SEARCH_RESULTS_HANDLE,searchHandle}
@sa #ifr_GetSearchResult
@ingroup search
*/
IFACEAPI int ifr_SearchResultsCount(IFR_SEARCH_RESULTS_HANDLE searchHandle);

/** @getitem{IFR_DISTANCERESULT,IFR_SEARCH_RESULTS_HANDLE,searchHandle}
@sa #ifr_SearchResultsCount

@ingroup search
*/
IFACEAPI IFR_DISTANCERESULT *ifr_GetSearchResult(IFR_SEARCH_RESULTS_HANDLE searchHandle, int index);


/**
Sets disance thresholds which affect confidence in results.
Imagus can advise on suitable values for specific tasks.
@handleparam{IFR_SEARCH_HANDLE,searchHandle}

@param rejectDistance   the RejectDistance 
@param acceptDistance   the AcceptDistance 
@param lowMargin        the Low Margin 
@param highMargin       the Hight Margin 
@ifr_return




Distance test                                       | Confidence result
----------------------------------------------------|------------------
Result Distance < Accept Distance                   | Green Result (1)
Result Distance > Reject Distance                   | Red Result(3)
Accept Distance < Result Distance < Reject Distance | Use margin thresholds

@f$margin = (distance of number 2 result) - (distance of number 1 result)@f$

Margin test                                         | Confidence result
----------------------------------------------------|------------------
margin > High Margin                                | Green Result(1)
margin < Low Margin                                 | Red Result(3)
Reject Margin < margin < AcceptMargin               | Yellow Result(2)


Suitable values for single face per enrolment in probe vs single face per enrolment in gallery
Metric          |value
----------------|--------
rejectDistance  | 0.86
acceptDistance  | 0.75
lowMargin       | 0.015
highMargin      | 0.03

Suitable values for 6 faces  per enrolment in probe vs 6 faces  per enrolment in gallery
Metric          |value
----------------|--------
rejectDistance  | 0.76
acceptDistance  | 0.6
lowMargin       | 0.015
highMargin      | 0.03

@ingroup search
*/
IFACEAPI IFR_RETURN ifr_SearchSetConfidenceMeasures(IFR_SEARCH_HANDLE searchHandle, float rejectDistance, float acceptDistance, float lowMargin, float highMargin);

/**Use a specific algorithm for a search 
see #IFR_ALGORITHM
@handleparam{IFR_SEARCH_HANDLE,searchHandle}
@param algo #IFR_ALGORITHM to use 
@ifr_return
@ingroup search
*/
IFACEAPI IFR_RETURN ifr_SearchSetAlgorithmVersion(IFR_SEARCH_HANDLE searchHandle, IFR_ALGORITHM algo);
/**Get the a specific algorithm a search is using
see #IFR_ALGORITHM
@handleparam{IFR_SEARCH_HANDLE,searchHandle}
@return algo #IFR_ALGORITHM in use 
@ingroup search
*/
IFACEAPI IFR_ALGORITHM ifr_SearchGetAlgorithmVersion(IFR_SEARCH_HANDLE searchHandle);

/**
Return the facelist from a search object
This is the facelist that a search will/has used for the search.
This needs to be populated with @ref faces, see #ifr_AddToFaceList
The #IFR_SEARCH_HANDLE keeps hold of a referance to the same facelist internally, so there is no need to inform the handle that it has changed.
@note Changing the contents of this facelist after #ifr_Search has been called will not affect the search results, but will attach the wrong facelist to the search results.
@handleparam{IFR_SEARCH_HANDLE,searchHandle}
@rethandle{IFR_FACELIST_HANDLE}
@ingroup search
*/
IFACEAPI IFR_FACELIST_HANDLE ifr_SearchGetFaceList(IFR_SEARCH_HANDLE searchHandle);

/**
Return search object flags
@handleparam{IFR_SEARCH_HANDLE,searchHandle}
@return The search flags
@ingroup search
*/
IFACEAPI IFR_SEARCH_FLAGS ifr_SearchGetFlags(IFR_SEARCH_HANDLE searchHandle);

/**
Set search object flags.
@note the object flags are entirely replaced with the new values.
@handleparam{IFR_SEARCH_HANDLE,searchHandle}
@param Flags The flags to set. see #IFR_SEARCH_FLAGS, @note #IFR_SEARCH_NORMALISED is not supported in ifr_Search, use ifr_Search2
@ifr_return
@ingroup search

*/
IFACEAPI IFR_RETURN ifr_SearchSetFlags(IFR_SEARCH_HANDLE searchHandle, IFR_SEARCH_FLAGS Flags);


/**
@brief  Sets the person of interest for the search.

if this is set to any uuid, then the only person looked for in the database is that person.
this overrides any tags or extended searches
The only results will be for this person ( 1 or many depending on the unique flag)
@note, match quality will be based on the distance thresholds only,
and it is possible it may come out as 1 even if there is another person in the db which is a better match
set the IFR_UUID to a null uuid to reset a search handle

@handleparam{IFR_SEARCH_HANDLE,searchHandle}
@param  person The person.

@ifr_return
@ingroup search
*/
IFACEAPI IFR_RETURN ifr_SearchSetPersonOfInterest(IFR_SEARCH_HANDLE searchHandle, IFR_UUID person);


/** Sets the Tag Expression used to filter the search
@sa @ref tags
The search result will only contain people that match the tag filters applied
@handleparam{IFR_SEARCH_HANDLE,searchHandle}
@handleparam{IFR_TAG_EXPRESSION_HANDLE,tagExpr, the tags to filter the search on}

@ifr_return
@ingroup search

*/
IFACEAPI IFR_RETURN ifr_SearchSetTagExpression(IFR_SEARCH_HANDLE searchHandle, IFR_TAG_EXPRESSION_HANDLE tagExpr);

/**
Add a filter tag to a search
@deprecated use #ifr_SearchSetTagExpression
@handleparam{IFR_SEARCH_HANDLE,searchHandle}
@param  tag     The tag to add.
@param  include 1/0 to include/exclude the tag from the search results.
@ifr_return
@ingroup search

*/
DEPRECATED_IFACEAPI IFR_RETURN ifr_SearchAddTag(IFR_SEARCH_HANDLE searchHandle, const char *tag, int include);

/**
Removes a tag from a search handle.
@deprecated use #ifr_SearchSetTagExpression
@handleparam{IFR_SEARCH_HANDLE,searchHandle}
@param  tag     The tag.
@ifr_return
@ingroup search

*/
DEPRECATED_IFACEAPI IFR_RETURN ifr_SearchRemoveTag(IFR_SEARCH_HANDLE searchHandle, const char *tag);

/**
@brief  Gets the number of include or exclude tags that are attached to the search.
@handleparam{IFR_SEARCH_HANDLE,searchHandle}
@param  include if 1 returns include tags, 0 returns exclude tags
@return The number of tags.
@ingroup search
*/
IFACEAPI size_t ifr_SearchGetNumTags(IFR_SEARCH_HANDLE searchHandle, int include);

/**
Gets the tag at index position index, this can either return include tags or exclude tags
@handleparam{IFR_SEARCH_HANDLE,searchHandle}
@param  include if 1 returns include tags, 0 returns exclude tags
@param  index   Zero-based index of the tag.
@return null if it fails, else the tag.
@ingroup search
*/
IFACEAPI const char *ifr_SearchGetTag(IFR_SEARCH_HANDLE searchHandle, int include, size_t index);

/**
Return the maximum number of items a search object can find.
@handleparam{IFR_SEARCH_HANDLE,searchHandle}
@return The current maximum number of search results.
@ingroup search
*/
IFACEAPI int ifr_SearchGetMaximumNumberOfResults(IFR_SEARCH_HANDLE searchHandle);

/**
Sets the maximum number of items a search object can find.
@handleparam{IFR_SEARCH_HANDLE,searchHandle}
@param MaximumResults	The new maximum number of results.
@ifr_return
@ingroup search
*/
IFACEAPI IFR_RETURN ifr_SearchSetMaximumNumberOfResults(IFR_SEARCH_HANDLE searchHandle, int MaximumResults);

/**
Return the number of items a search object has found
@handleparam{IFR_SEARCH_HANDLE,searchHandle}
@return The number of search results.
@ingroup search
*/
IFACEAPI int ifr_SearchGetNumberOfResults(IFR_SEARCH_HANDLE searchHandle);

/**
Return a single result from the search object.
@handleparam{IFR_SEARCH_HANDLE,searchHandle}
@param index		A Zero based index selecting the result to return.

@return A pointer to a single search result. @objectlocal
@ingroup search
*/
IFACEAPI IFR_DISTANCERESULT *ifr_SearchGetResult(IFR_SEARCH_HANDLE searchHandle, int index);

/**
Counts the number of people enrolled in the database.
@deprecated Use ifr_CountPeople2;
@handleparam{IFR_CONTEXT_HANDLE,context}
@param count		A pointer to a variable that will contain the result.
@callbackparam{IFR_UInt32CompletionRoutine,callback}
@userparam
@ifr_return
@ingroup facedb
*/
IFACEAPI IFR_RETURN ifr_CountPeople(IFR_CONTEXT_HANDLE context, uint32_t *count, IFR_UInt32CompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);
/**
Counts the number of people enrolled in the database.

@handleparam{IFR_CONTEXT_HANDLE,context}
@callbackparam{IFR_UInt32CompletionRoutine,callback}
@userparam
@return if the callback was not supplied, the count, otherwise 0, and the result comes in the callback. @setslasterror
@ingroup facedb
*/
IFACEAPI uint32_t ifr_CountPeople2(IFR_CONTEXT_HANDLE context, IFR_UInt32CompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);

/**
Counts the number of images enrolled in the database.

@deprecated Use ifr_CountImages2;
@handleparam{IFR_CONTEXT_HANDLE,context}
@param count		A pointer to a variable that will contain the result.
@callbackparam{IFR_UInt32CompletionRoutine,callback}
@userparam
@ifr_return
@ingroup facedb
*/
IFACEAPI IFR_RETURN ifr_CountImages(IFR_CONTEXT_HANDLE context, uint32_t *count, IFR_UInt32CompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);
/**
Counts the number of images enrolled in the database.

@handleparam{IFR_CONTEXT_HANDLE,context}
@callbackparam{IFR_UInt32CompletionRoutine,callback}
@userparam
@return if the callback was not supplied, the count, otherwise 0, and the result comes in the callback. @setslasterror
@ingroup facedb
*/
IFACEAPI uint32_t ifr_CountImages2(IFR_CONTEXT_HANDLE context, IFR_UInt32CompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);

/**
Counts the number of enrollements in the database.

@deprecated Use ifr_CountEnrolments2;
@handleparam{IFR_CONTEXT_HANDLE,context}
@param count		A pointer to a variable that will contain the result.
@callbackparam{IFR_UInt32CompletionRoutine,callback}
@userparam
@ifr_return
@ingroup facedb*/

IFACEAPI IFR_RETURN ifr_CountEnrolments(IFR_CONTEXT_HANDLE context, uint32_t *count, IFR_UInt32CompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);
/**
Counts the number of enrollements in the database.

@handleparam{IFR_CONTEXT_HANDLE,context}
@callbackparam{IFR_UInt32CompletionRoutine,callback}
@userparam
@return if the callback was not supplied, the count, otherwise 0, and the result comes in the callback. @setslasterror
@ingroup facedb
*/
IFACEAPI uint32_t ifr_CountEnrolments2(IFR_CONTEXT_HANDLE context, IFR_UInt32CompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);

/**
Counts the number of Features in the database.

@deprecated Use ifr_CountFeatures2;
@handleparam{IFR_CONTEXT_HANDLE,context}
@param count		A pointer to a variable that will contain the result.
@callbackparam{IFR_UInt32CompletionRoutine,callback}
@userparam
@ifr_return
@ingroup facedb
*/
IFACEAPI IFR_RETURN ifr_CountFeatures(IFR_CONTEXT_HANDLE context, uint32_t *count, IFR_UInt32CompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);
/**
Counts the number of features in the database.

@handleparam{IFR_CONTEXT_HANDLE,context}
@callbackparam{IFR_UInt32CompletionRoutine,callback}
@userparam
@return if the callback was not supplied, the count, otherwise 0, and the result comes in the callback. @setslasterror
@ingroup facedb
*/
IFACEAPI uint32_t ifr_CountFeatures2(IFR_CONTEXT_HANDLE context, IFR_UInt32CompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);







/**
Gets the latest audit identifier from the DB
This is valid for the master DB, Slave DBs may have local changes, which may need to be uploaded.

@handleparam{IFR_CONTEXT_HANDLE,context}
@callbackparam{IFR_Int64CompletionRoutine,callback}
@userparam
@return if the callback was not supplied, the audit identifer, otherwise 0, and the result comes in the callback. @setslasterror
@ingroup facedb
*/
IFACEAPI int64_t ifr_GetLastAudit(IFR_CONTEXT_HANDLE context, IFR_Int64CompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);










/**
Detects faces in an image
@handleparam{IFR_DETECTOR_HANDLE,detector}
@handleparam{IFR_IMAGE_HANDLE,image}
@callbackparam{IFR_DetectionCompletionRoutine,callback}
@userparam
@note: this is the same as calling #ifr_DetectFacesInImage2 with a flags setting of IFR_DETECTION_SIMPLE
@deferred_rethandle{IFR_DETECTOR_RESULT_HANDLE}
@ingroup facedetection
*/
IFACEAPI IFR_DETECTOR_RESULT_HANDLE ifr_DetectFacesInImage(IFR_DETECTOR_HANDLE detector, IFR_IMAGE_HANDLE image, IFR_DetectionCompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);


/**
Detects faces in an image

@handleparam{IFR_DETECTOR_HANDLE,detector}
@handleparam{IFR_IMAGE_HANDLE,image}
@param flags     A flag denoting which type of detection to perform see #IFR_DETECTION_FLAGS
@callbackparam{IFR_DetectionCompletionRoutine,callback}
@userparam
@deferred_rethandle{IFR_DETECTOR_RESULT_HANDLE}
@ingroup facedetection
*/
IFACEAPI IFR_DETECTOR_RESULT_HANDLE ifr_DetectFacesInImage2(IFR_DETECTOR_HANDLE detector, IFR_IMAGE_HANDLE image, IFR_DETECTION_FLAGS flags, IFR_DetectionCompletionRoutine callback DEFAULTPARAM, void *user DEFAULTPARAM);

/** @getcount{#IFR_DETECTORRESULT,IFR_DETECTOR_RESULT_HANDLE,handle}
@sa #ifr_GetString
@ingroup facedetection
*/
IFACEAPI size_t ifr_DetectorResultGetNumberOfResults(IFR_DETECTOR_RESULT_HANDLE handle);

/** @getitem{#IFR_DETECTORRESULT,IFR_DETECTOR_RESULT_HANDLE,handle}
@sa #ifr_GetNumStrings
@ingroup facedetection
*/
IFACEAPI const IFR_DETECTORRESULT *ifr_DetectorResultGetResult(IFR_DETECTOR_RESULT_HANDLE handle, size_t index);

/**
Call this function to parameterise the shared face detectors. 
This function must be called before any function which used any face detection capability.
e.g before any detector handles are created. This includes any video or still sources.
If you have been supplied with an alternative face detector or landmark file use that here.


@param  path    Full pathname of the file containing the face detector.
        @param  landmarkFile    Full pathname of the file containing the landmark detector.
@param  numCPU  Number of CPU face detection threads to use
@param  numCUDA Max Number of CUDA enabled devices to use.

@ifr_return
@ingroup facedetection
 */

IFACEAPI IFR_RETURN ifr_SetupDetectors(const char *path, const char *landmarkFile, int numCPU, int numCUDA);

/**
Allocates a face detector object

@rethandle{IFR_DETECTOR_HANDLE}
@ingroup facedetection
*/
IFACEAPI IFR_DETECTOR_HANDLE ifr_AllocDetector(void);

/**
Sets the scaling factor for the face detection boxes. 
It is not recommeded to call this unless advised by Imagus
Different face detectors can return different sized boxes. A box that's too small might not give
optimal face quality results. By adjusting the box returned by the detector we can optimise the
box size to give the best face quality outcome.

The default (if this is not called) is to select a value that works well for most detectors.
You would call this to fine tune the detector output based on the resultant face quality.

@handleparam{IFR_DETECTOR_HANDLE,detector}
@param scalingFactor            The scaling factor applied to the box.

@ifr_return
@ingroup facedetection
*/
IFACEAPI IFR_RETURN ifr_DetectorSetOutputBoxScalingFactor(IFR_DETECTOR_HANDLE detector, float scalingFactor);

/**
Sets the minimum and maximum sizes of faces to search for in pixels
@handleparam{IFR_DETECTOR_HANDLE,detector}
@param xmin min width
@param ymin min height
@param xmax max width
@param ymax max height 
@ifr_return
@ingroup facedetection
*/
IFACEAPI IFR_RETURN ifr_DetectorSetFaceSizeWindow(IFR_DETECTOR_HANDLE detector, int xmin, int ymin, int xmax, int ymax);


///// tag expressions
/**
Creates a new empty tag expression
@rethandle{IFR_TAG_EXPRESSION_HANDLE}
@ingroup tags
*/
IFACEAPI IFR_TAG_EXPRESSION_HANDLE ifr_CreateTagExpression(void);
/**
Sets flags affecting the tag expressions. see #IFR_TAG_FLAGS
@handleparam{IFR_TAG_EXPRESSION_HANDLE,tagHandle}
@param flags the flags to apply, e.g. #IFR_TAG_ANY
@ifr_return
@ingroup tags
*/
IFACEAPI IFR_RETURN ifr_SetTagFlags(IFR_TAG_EXPRESSION_HANDLE tagHandle, IFR_TAG_FLAGS flags);
/**
Gets flags affecting the tag expressions. see #IFR_TAG_FLAGS
@handleparam{IFR_TAG_EXPRESSION_HANDLE,tagHandle}
@return the flags
@ingroup tags
*/
IFACEAPI IFR_TAG_FLAGS ifr_GetTagFlags(IFR_TAG_EXPRESSION_HANDLE tagHandle);
/**
Removes a tag from an expression
@handleparam{IFR_TAG_EXPRESSION_HANDLE,tagHandle}
@param tag The tag
@ifr_return
@ingroup tags
*/
IFACEAPI IFR_RETURN ifr_RemoveTag(IFR_TAG_EXPRESSION_HANDLE tagHandle, const char *tag);
/**
Removes all tags from an expression
@handleparam{IFR_TAG_EXPRESSION_HANDLE,tagHandle}
@ifr_return
@ingroup tags
*/
IFACEAPI IFR_RETURN ifr_ClearTags(IFR_TAG_EXPRESSION_HANDLE tagHandle);
/**
Gets the count of tags in an #IFR_TAG_EXPRESSION_HANDLE
@handleparam{IFR_TAG_EXPRESSION_HANDLE,tagHandle}
@param include 1 for inculde tags, 0 for exclude tags
@return the number of tags @setslasterror
@ingroup tags
*/
IFACEAPI size_t ifr_GetNumTags(IFR_TAG_EXPRESSION_HANDLE tagHandle, int include);
/**
Gets the include or exclude tag at specified index #IFR_TAG_EXPRESSION_HANDLE
@handleparam{IFR_TAG_EXPRESSION_HANDLE,tagHandle}
@param include 1 for inculde tags, 0 for exclude tags
@param index the index of the tag
@return the specified tag @setslasterror
@ingroup tags
*/
IFACEAPI const char *ifr_GetTag(IFR_TAG_EXPRESSION_HANDLE tagHandle, int include, size_t index);
/**
Removes all tags from an expression
@handleparam{IFR_TAG_EXPRESSION_HANDLE,tagHandle}
@param include 1 to add as an inculde, 0 for exclude tags
@param tag The tag to add
@ifr_return
@ingroup tags
*/
IFACEAPI IFR_RETURN ifr_AddTag(IFR_TAG_EXPRESSION_HANDLE tagHandle, const char *tag, int include);

/////////////

/**
Function definiton for a deleter for an IFR_BUFFER_HANDLE
The first parameter is a pointer to the begining of the buffer,
The second is the opaque void * user parameter passed to the #ifr_AllocBuffer funtion
@ingroup buf
*/
typedef void (*IFR_BufferDeleter)(void *, void *); 

/** Creates a new buffer with data owned and allocated by the api
@param datasize the size of the buffer to allocate in bytes
@rethandle{IFR_BUFFER_HANDLE}
@ingroup buf
*/
IFACEAPI IFR_BUFFER_HANDLE ifr_AllocBuffer(size_t datasize);

/** Creates a new buffer from a file with data owned and allocated by the api
@param filepath the path to the file to load into the buffer
@rethandle{IFR_BUFFER_HANDLE}
@ingroup buf
*/
IFACEAPI IFR_BUFFER_HANDLE ifr_CreateBufferFromFile(const char * filepath);


/** Save a buffer to a file
The filename passed in must not exist, but the directory must exist
@handleparam{IFR_BUFFER_HANDLE, bufferHandle}
@param filepath the path oo the file to save the buffer into this must not exist 
@ifr_return Will return an #IFR_INVALID_PATH or #IFR_CANNOT_WRITE_TO_FILE
@ingroup buf
*/
IFACEAPI IFR_RETURN ifr_SaveBufferToFile(IFR_BUFFER_HANDLE bufferHandle, const char * filepath);


/** Creates a new buffer with data owned and allocated and deleted by the user application
@param data a pointer to the begining of the buffer
@param datasize the size of the buffer
@param deleter This is a function that is called when the memory is no longer needed by the api
@param user This is an opaque pointer passed into the deleter when called.
@rethandle{IFR_BUFFER_HANDLE}
@ingroup buf
*/
IFACEAPI IFR_BUFFER_HANDLE ifr_CreateBuffer(void *data, size_t datasize, IFR_BufferDeleter deleter, void *user);
/** Returns the size of the buffer in bytes
@handleparam{IFR_BUFFER_HANDLE, bufferHandle} 
@returns the size of the buffer @setslasterror
@ingroup buf
*/
IFACEAPI size_t ifr_BufferGetSize(IFR_BUFFER_HANDLE bufferHandle);
/** Returns the datapointer the the begining of the buffers
@handleparam{IFR_BUFFER_HANDLE, bufferHandle} 
@returns the pointer. @setslasterror
@ingroup buf
*/
IFACEAPI void *ifr_BufferGetData(IFR_BUFFER_HANDLE bufferHandle);

/**
Creates a facetracker
@param location This is a user chosen #IFR_UUID which will be reporeted in every track that the tracker produces
@rethandle{IFR_FACETRACKER_HANDLE}
@ingroup tracks
*/
IFACEAPI IFR_FACETRACKER_HANDLE ifr_CreateFaceTracker(IFR_UUID location);

/** 
Set the number of milliseconds a track without updates lasts
@handleparam{IFR_FACETRACKER_HANDLE,handle}
@param milliseconds the time in milleseconds between updates
@ifr_return
@ingroup tracks
*/
IFACEAPI IFR_RETURN ifr_TrackerSetDecayTime(IFR_FACETRACKER_HANDLE handle, IFR_TIME milliseconds);
/** Sets the max number best faces a track will retain, 
these will be kept according to the best quality
@handleparam{IFR_FACETRACKER_HANDLE,handle}
@param numFaces the number of faces to keep in the track
@ifr_return
@ingroup tracks
*/
IFACEAPI IFR_RETURN ifr_TrackerSetBestFaces(IFR_FACETRACKER_HANDLE handle, int numFaces);
/** This tells the tracker the max age in frames of the faces it can keep.
A face is kept in the track if the face is younger than this number of updates.
@handleparam{IFR_FACETRACKER_HANDLE,handle}
@param numFrames The age of the frames to allow in  the track
@ifr_return
@ingroup tracks
*/
IFACEAPI IFR_RETURN ifr_TrackerSetBestFaceMaxAge(IFR_FACETRACKER_HANDLE handle, int numFrames);
/** remove all entrys with a timestamp >= timestamp
 if the track ends up empty, then it will either be refilled or removed 
@handleparam{IFR_FACETRACKER_HANDLE,handle}
@param time the time to rewind the tracks to
@ifr_return
@ingroup tracks
*/
IFACEAPI IFR_RETURN ifr_TrackerRewindPast(IFR_FACETRACKER_HANDLE handle, IFR_TIME time);

/** Resets the tracker, removing all tracks, all tracks will be correctly reported as finished
@handleparam{IFR_FACETRACKER_HANDLE,handle}
@ifr_return
@ingroup tracks
*/
IFACEAPI IFR_RESULTIDS_HANDLE ifr_TrackerReset(IFR_FACETRACKER_HANDLE handle);


/** Sets the time of the next frame to be handled.
The tracker update cycle runs
Set the time of the frame. #ifr_TrackerIncrementTime\n 
Add all detections. #ifr_TrackerAddDetections\n
Mark frame as complete.#ifr_TrackerCompleteFrame\n
@handleparam{IFR_FACETRACKER_HANDLE,handle}
@param time the time next frame to be updated.
@ifr_return
@ingroup tracks
@sa #ifr_TrackerAddDetections, #ifr_TrackerAddDetections2, #ifr_TrackerCompleteFrame
*/
IFACEAPI IFR_RETURN ifr_TrackerIncrementTime(IFR_FACETRACKER_HANDLE handle, IFR_TIME time);

/** Marks a frame complete for the tracker, so track updates will be called.
@handleparam{IFR_FACETRACKER_HANDLE,handle}
@ifr_return
@sa #ifr_TrackerAddDetections, #ifr_TrackerAddDetections2, #ifr_TrackerIncrementTime
@ingroup tracks
*/
IFACEAPI IFR_RESULTIDS_HANDLE ifr_TrackerCompleteFrame(IFR_FACETRACKER_HANDLE handle);

/** Adds the results of a facedetection call to the tracker
@handleparam{IFR_FACETRACKER_HANDLE,handle}
@handleparam{IFR_DETECTOR_RESULT_HANDLE,detections}
@handleparam{IFR_IMAGE_HANDLE,image,  The image to which the detections refer so faces can be collected}
@ifr_return
@sa facedetection
@ingroup tracks
*/
IFACEAPI IFR_RETURN ifr_TrackerAddDetections(IFR_FACETRACKER_HANDLE handle, IFR_DETECTOR_RESULT_HANDLE detections, IFR_IMAGE_HANDLE image);
/** Adds facedetection recrods to the tracker
@handleparam{IFR_FACETRACKER_HANDLE,handle}
@param detections array of IFR_FACEDETECTOR structures with detections
@param detCount size of the detections array
@handleparam{IFR_IMAGE_HANDLE,image, The image to which the detections refer so faces can be collected}
@ifr_return
@sa facedetection
@ingroup tracks
*/
IFACEAPI IFR_RETURN ifr_TrackerAddDetections2(IFR_FACETRACKER_HANDLE handle, IFR_DETECTORRESULT *detections, size_t detCount, IFR_IMAGE_HANDLE image);

/** Creates a polygonal region within a tracker 
@warning region code is experimental
@handleparam{IFR_FACETRACKER_HANDLE,handle}
@param points array of points in depicting corners of the region
@param pointCount number of points in the points array
@param regionUUID user supplied id of the region
@ifr_return
@ingroup tracks
*/
IFACEAPI IFR_RETURN ifr_TrackerCreatePolyRegion(IFR_FACETRACKER_HANDLE handle, IFR_POINT *points, size_t pointCount, IFR_UUID regionUUID);

/** Deletes a region in the tracker
@warning region code is experimental
any track currently in the region will still cause an event to occur on the next track update, as it would have if it left the region.
@handleparam{IFR_FACETRACKER_HANDLE,handle}
@param regionUUID user supplied id of the region
@ifr_return
@ingroup tracks
*/
IFACEAPI IFR_RETURN ifr_TrackerDeleteRegion(IFR_FACETRACKER_HANDLE handle, IFR_UUID regionUUID);

/** Set a callback to happen whenever a track event occurs
@handleparam{IFR_FACETRACKER_HANDLE,handle}
@callbackparam{IFR_TrackerCallbackRoutine,callback}
@callbackhandleparam
@ifr_return
@ingroup tracks
*/
IFACEAPI IFR_RETURN ifr_TrackerSetCallback(IFR_FACETRACKER_HANDLE handle, IFR_TrackerCallbackRoutine callback, IFR_CALLBACK_HANDLE cbHandle);


/**
Function definiton for a deleter for an IFR_CALLBACK_HANDLE
The parameter is an opaque void * user parameter passed to the #ifr_CreateManagedCallback funtion
@ingroup callbacks
*/
typedef void (*IFR_CallbackContextDeleter)(void *ctx);               

/**
Creates an #IFR_CALLBACK_HANDLE
This handle needs to be freed using #ifr_Free, but the callback will still occur until the object the callback was attached to has completed.
The callback can be cancelled prematurely with #ifr_CancelCallback.
Depending on the function called used this may or may not cancel the associated operation. See specific function documentation.

@userparam
@param deleter The function that will notify the application when the user pointer is no longer going to be accessed.
@ingroup callbacks
*/
IFACEAPI IFR_CALLBACK_HANDLE ifr_CreateManagedCallback(void *user, IFR_CallbackContextDeleter deleter);

/** Cancels a callback handle.
Any callback function associated with this handle will not called again once this function is complete.
This function is safe to call within a callback managed by it.
This does not free the callback handle, use #ifr_Free to do that

@note Any callbacks currently occuring on a different thread will complete, but new ones will not happen again.
@handleparam{IFR_CALLBACK_HANDLE,handle}
@ifr_return
@ingroup callbacks
*/
IFACEAPI IFR_RETURN ifr_CancelCallback(IFR_CALLBACK_HANDLE handle);


//! @cond DONTDOXYCOMMENT
IFACEAPI IFR_TRACKLETBUFFER_HANDLE ifr_CreateTrackBuffer(const char *filename, size_t size, IFR_FEATURESET algorithmType);
IFACEAPI IFR_TRACKLETBUFFER_HANDLE ifr_OpenTrackBuffer(const char *filename);
IFACEAPI IFR_RETURN ifr_TrackBufferAddTracklet(IFR_TRACKLETBUFFER_HANDLE buf, IFR_TRACKLET_HANDLE trklet);
IFACEAPI IFR_RETURN ifr_TrackBufferAdd(IFR_TRACKLETBUFFER_HANDLE buf, IFR_TIME startTime, IFR_TIME endTime, IFR_UUID trackId, IFR_UUID trackletId, IFR_UUID locationId, IFR_FACELIST_HANDLE facelist);


IFACEAPI IFR_TRACKLETBUFFERSEARCHRESULTS_HANDLE ifr_TrackBufferSearch(IFR_TRACKLETBUFFER_HANDLE buf, IFR_FACELIST_HANDLE flist, int mergeTracklets, float threshold);
IFACEAPI IFR_RETURN ifr_TrackBufferSearchAsync(IFR_TRACKLETBUFFER_HANDLE buf, IFR_FACELIST_HANDLE flist, int mergeTracklets,float threshold, IFR_HandleCompletionRoutine callback, void *user);
IFACEAPI const IFR_BUFFER_SEARCH_RESULT *ifr_TrackBufferResultsGet(IFR_TRACKLETBUFFERSEARCHRESULTS_HANDLE handle, int Index);
IFACEAPI int ifr_TrackBufferResultsCount(IFR_TRACKLETBUFFERSEARCHRESULTS_HANDLE handle);
IFACEAPI IFR_ALGORITHM ifr_TrackBufferGetAlgorithm(IFR_TRACKLETBUFFER_HANDLE buf);
IFACEAPI IFR_STATS ifr_TrackBufferResultsGetStats(IFR_TRACKLETBUFFERSEARCHRESULTS_HANDLE handle);
//! @endcond


/**
Generates a new UUID
@return a new populated #IFR_UUID
@ingroup UUID
*/
IFACEAPI IFR_UUID ifr_GenerateUUID(void);
/**
Generates a new Null populated UUID
@return a new null #IFR_UUID
@ingroup UUID
*/
IFACEAPI IFR_UUID ifr_GenerateNullUUID(void);

/**
Generates a new name based uuid, this is generated the same way based on the names and namespace supplied eachtime
@param nspace a string
@param name a string
@return a new populated #IFR_UUID
@ingroup UUID
*/
IFACEAPI IFR_UUID ifr_GenerateUUIDFromName(const char *nspace, const char *name);

/** Converts an #IFR_UUID to a string
@param uid a UUID
@param str a pre allocated buffer with enough room for the uuid (32 bytes)
@param len the size of the preallocated buffer;
@return the str value , @setslasterror
@ingroup UUID
*/
IFACEAPI const char *ifr_UUIDToChar(IFR_UUID uid, char *str, size_t len);

/** Converts an #IFR_UUID to a string
@param uid a UUID
@return the str value, @threadlocal
@ingroup UUID
*/
IFACEAPI const char *ifr_UUIDToChar2(IFR_UUID uid);

/** Converts a a string to a uuid
@param str a string with the uuid 
@param len the size of the string;
@return the IFR_UUID value
@ingroup UUID
*/
IFACEAPI IFR_UUID ifr_CharToUUID(const char *str, size_t len);


/** A Test function which asynchronusly sleeps
@handleparam{IFR_CONTEXT_HANDLE, context}
@param milliseconds The number of milliseconds to sleep for.
@callbackparam{IFR_UInt32CompletionRoutine,callback}
@userparam
@ingroup FaceDB
*/
IFACEAPI IFR_RETURN ifrinternal_Sleep(IFR_CONTEXT_HANDLE context, size_t milliseconds, IFR_UInt32CompletionRoutine callback, void *user);



IFACEAPI IFR_DISPLAY_HANDLE ifr_CreateDisplay(const char * title);
IFACEAPI IFR_RETURN ifr_DisplayImage(IFR_DISPLAY_HANDLE display, IFR_IMAGE_HANDLE image);
IFACEAPI IFR_RETURN ifr_DisplayFace(IFR_DISPLAY_HANDLE display, IFR_FACE_HANDLE face);
IFACEAPI IFR_RETURN ifr_DisplayFaceList(IFR_DISPLAY_HANDLE display, IFR_FACELIST_HANDLE facelist);

/** Pauses the display for a specific time ( 0 for wait for keypress) this is required after any display code to allow display 
*/
IFACEAPI IFR_RETURN ifr_DisplayPause(IFR_DISPLAY_HANDLE display, int milliseconds);

/** A simple function which waits for a keypress crossplatform
*/
IFACEAPI IFR_RETURN ifr_WaitKey();




/**
Get face confidence from DNN face distance.

**/
IFACEAPI float ifr_GetConfidence(float dist);

IFACEAPI float ifr_GetConfidenceSmooth(float dist);


#ifdef __cplusplus
} // extern "C"
#endif

//! @brief	Frees the handle passed, and sets the value to zero
//!
//! @param	ptr	to The Handle to free.
//! @ingroup handles





#ifdef __cplusplus
template <typename T>
inline IFR_RETURN ifr_Freep(T *&ptr)
{
    IFR_RETURN result = ifr_Free(ptr);
    ptr = NULL;
    return result;
}

//! c++ template to make #ifr_Duplicate safer to use
//!
//! @param	handle, the handle to duplicate
//! @return a new handle to the same object
//! @ingroup handles
template <typename T>
inline T ifr_Dup(T handle)
{
    return reinterpret_cast<T>(ifr_Duplicate(handle));
}

#endif

#endif
