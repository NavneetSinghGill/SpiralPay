//!
//! @file    iFaceRecDefs.h
//!
//! @brief   Declares the interface definitions class.
//!
//!            Copyright (c) 2013 Imagus. All rights reserved.
//!
#if !defined __IMAGUS_FACE_DEFINITIONS__
#define __IMAGUS_FACE_DEFINITIONS__

#if defined(__has_include) 
	#if __has_include("ImagusTypes.h")
		#include "ImagusTypes.h"
	#else 
		#include <ImagusTypes/ImagusTypes.h>
	#endif
#else 
	#include <ImagusTypes/ImagusTypes.h>
#endif
#include <stddef.h>
#include <stdint.h>
#include <string.h>
#ifdef __cplusplus
extern "C" {
#endif

//! @typedef    int32_t IFR_DB_FLAGS
//!
//! @brief  Database opening flag definitions.
/*!         These flags can be combined to dictate how the databases are opened, for example \n
            
            @code{.c} IFR_DB_OPEN | IFR_DB_READONLY @endcode
             opens an existing database in read only mode 

            @code{.c}  IFR_DB_OPEN  @endcode
             will only open an existing DB and fail if one does not exist 
            @code{.c}  IFR_DB_CREATE @endcode
             will only create a new database and return an error if one exists 
            @code{.c}  IFR_DB_OPEN | IFR_DB_CREATE  @endcode
             will open an existing DB or create a new one.
             @ingroup facedb
  Flag                       | Meaning
  ---------------------------|-----------------------------------------------------
  IFR_DB_OPEN                | Expect to open an existing database
  IFR_DB_CREATE              | Expect to create a database  @note PostgreSQL databases ignore this flag, as a database must already exist to be used 
  IFR_DB_READONLY            | Open the database in read only mode
  IFR_DB_ALLOWUPGRADE;       | Allows an inplace upgrade of the database if required
  IFR_DB_UPDATE_ALGORITHMS   | updates models and algorithms in the database if required
  IFR_DB_VACUUM              | defragments and shrinks db if required
  IFR_DB_WIPEDB              | deletes entire contents of database, and reinitialises, must be used in conjunction with IFR_DB_OPEN and not IFR_DB_READONLY

*/


typedef int32_t IFR_DB_FLAGS;
/*!@cond DONTDOXYCOMMENT */
static const IFR_DB_FLAGS IFR_DB_OPEN = 1;               
static const IFR_DB_FLAGS IFR_DB_CREATE = 2;             
static const IFR_DB_FLAGS IFR_DB_READONLY = 4;           
static const IFR_DB_FLAGS IFR_DB_ALLOWUPGRADE = 8;       
static const IFR_DB_FLAGS IFR_DB_UPDATE_ALGORITHMS = 16; 
static const IFR_DB_FLAGS IFR_DB_VACUUM = 32;            
static const IFR_DB_FLAGS IFR_DB_BULK_INSERT_MODE = 64;
static const IFR_DB_FLAGS IFR_DB_WIPEDB = 128;

/*! @endcond */

/*! @typedef int32_t IFR_SEARCH_FLAGS

    @brief There are search flags that can be activated. 
    @ingroup search
@{ */
typedef int32_t IFR_SEARCH_FLAGS;
static const IFR_SEARCH_FLAGS IFR_SEARCH_UNIQUE = 1;        ///< will return only 1 result per person
static const IFR_SEARCH_FLAGS IFR_SEARCH_TAG_ANY = 2;       ///< When include tags are added to the search return results for any, rather than the default of all
static const IFR_SEARCH_FLAGS IFR_SEARCH_EXTENDED = 4;      ///< Run a more intensive search @deprecated This is to be removed in future versions
static const IFR_SEARCH_FLAGS IFR_SEARCH_USE_SEEDED_DB = 8; ///< Use the internal Cohorts to extend the database size to > 200 faces to enable better confidence on small databases @deprecated This is to be removed in future versions
static const IFR_SEARCH_FLAGS IFR_SEARCH_NORMALISED = 16;   ///< Normalise results if normalisation is possible.
/*! @} */

/*! @typedef int32_t IFR_VERIFY_FLAGS
@ingroup verification
@{ */
typedef int32_t IFR_VERIFY_FLAGS;
static const IFR_VERIFY_FLAGS IFR_VERIFY_MRH = 1;  ///< use MRH feature for verification
static const IFR_VERIFY_FLAGS IFR_VERIFY_V2 = 2;   ///< use IFRV2 feature for verification
/*! @} */

/*! @typedef int32_t IFR_TAG_FLAGS
    @ingroup tags
@{ */
typedef int32_t IFR_TAG_FLAGS;
static const IFR_TAG_FLAGS IFR_TAG_ANY = 2; ///< When include tags are used, this sets the expression to return for any of the included tags, rather than the default of all required
/*! @} */

/*! 
    @brief Image Colourspace

    These flags specify the colourspace of the raw images of the system 
    by default colour images are BGRA

    @ingroup images
@{ */

typedef enum IFR_IMAGE_FORMAT {
    IFR_DEFAULT_FORMAT = 0, ///< When Loading and saving images, does not specify a requested format, jsut uses what the image currently is
    IFR_GRAYSCALE = 1,      ///< 8 Bit Greyscale
    IFR_BGRA = 2,           ///< 32 Bit colour where the pixel order is Blue Greed Red Alpha ( alpha is generally ignored)
    IFR_RGBA = 3,           ///< 32 Bit colour where the pixel order is Red Greed Blue Alpha ( alpha is generally ignored)
    IFR_BGR = 4,            ///< 24 Bit colour where the pixel order is Blue Greed Red
    IFR_RGB = 5,            ///< 24 Bit colour where the pixel order is Red Greed Blue
	IFR_GRAY16 = 6,         ///< 16 Bit Greyscale
    IFR_NV12 = 7,           ///< YUYV...
} IFR_IMAGE_FORMAT;

/*! 
    @brief Image Compression Flags
    When compressing images these flags can be used to alter compression.
    */
typedef int32_t IFR_IMAGE_COMPRESSION;
static const IFR_IMAGE_COMPRESSION IFR_IMAGE_COMPRESSION_NONE = 0;           ///< No compression -- lossless required
static const IFR_IMAGE_COMPRESSION IFR_IMAGE_COMPRESSION_640x480 = (1 << 0); ///< Resize to 640x480 @deprecated Resize the image manually first if required
static const IFR_IMAGE_COMPRESSION IFR_IMAGE_COMPRESSION_BW = (1 << 1);      ///< Save the image in grayscale @deprecated Convert the colour manually first if required
static const IFR_IMAGE_COMPRESSION IFR_IMAGE_COMPRESSION_JPG = (1 << 2);     ///< Use Jpeg compression

/*! @} */

/*! 
    @brief Track event Values sent when the tracker detects a track has changed state

    When a tracker updates a track these flags are sent to indicate why the update occured

    @ingroup tracks
*/
typedef enum IFR_TRACKER_EVENT {
    IFR_TRACKER_TRACK_ADDED = 1,      ///< A new track has been started
    IFR_TRACKER_TRACK_REMOVED = 2,    ///< A Track has ended
    IFR_TRACKER_REGION_ENTERED = 3,   ///< A Track has entered a region in the video
    IFR_TRACKER_REGION_LEFT = 4,      ///< A Track has left a region in the video
    IFR_TRACKER_TRACKLET_UPDATED = 5, ///< A Track has had new information updated which is likely interesting
} IFR_TRACKER_EVENT;

/*! @brief Face image quality.
    Quality of the face image, there are three possible quality ratings. #IFR_HIGH (1), #IFR_MEDIUM (2), #IFR_LOW (3).
    @ingroup search
    */
typedef enum IFR_RESULT_QUALITY {
    IFR_HIGH = 1,   ///< A good prediction of a match given the distances and margins supplied
    IFR_MEDIUM = 2, ///< Not fully confident of a match but still a possibility (rare)
    IFR_LOW = 3,    ///< No confidence of a match
} IFR_RESULT_QUALITY;

//! @brief Face recognition algorithm selection - pick between 3.
/*! Three algorithms to choose from for high, medium, and low quality faces and/or environments.
    @ingroup search
    @{
        */
typedef enum IFR_ALGORITHM {
    IFR_ALGORITHM_DEFAULT_LOW = 0x01,   ///< DEPRECATED Choose this algorithm for faces with < 32 pixels between the eyes
    IFR_ALGORITHM_DEFAULT_MED = 0x02,   ///< DEPRECATED Choose this algorithm for high quality faces very well aligned
	IFR_ALGORITHM_DEFAULT_HIGH = 0x04,  ///< DEPRECATED Choose this for faces with quality > 32 pixels between the eyes
	IFR_ALGORITHM_DEFAULT_V2 = 0x10     ///<  Version 2 features, USE this unless instructed otherwise
} IFR_ALGORITHM;

/*! @} */

/*! @brief Feature Selection for algorithm models
    @ingroup search
*/
typedef enum IFR_FEATURESET {
    IFR_FEATURE_96 = 0x04,  ///< DEPRECATED Choose this for faces with quality > 32 pixels between the eyes
	IFR_FEATURE_48 = 0x01,  ///< DEPRECATED Choose this algorithm for faces with < 32 pixels between the eyes
	IFR_FEATURE_V2 = 0x10   ///<  Use This featureset unless instructed otherwise
} IFR_FEATURESET;

/*! @brief Flags to Control behaviour when creating faces

Flag                                |   Meaning
------------------------------------|----------------------------------
IFR_CREATE_FACE_FLAGS_NONE          | Default flag, does not affect processing
IFR_FACE_PRE_COMPUTE_HIGH           | Tells the system that the High FaceModel is going to be required, so start generating it before beign asked to
IFR_FACE_PRE_COMPUTE_FEATURESET_96  | Tells the system that the 96 pixel Featureset is going to be required, so start generating it before beign asked to
IFR_FACE_PRE_COMPUTE_MED            | Tells the system that the Medium FaceModel is going to be required, so start generating it before beign asked to
IFR_FACE_PRE_COMPUTE_LOW            | Tells the system that the Low FaceModel is going to be required, so start generating it before beign asked to
IFR_FACE_PRE_COMPUTE_FEATURESET_48  | Tells the system that the 48 pixel Featureset is going to be required, so start generating it before beign asked to
IFR_FACE_ASPECT_REFINE              | Refine the face before use @deprecated, use the Face Detectior with labeling and create the face from the result
IFR_FACE_IMAGE_NO_RESIZE            | Tells the system not to resize the face image when creating the face. Instead, it gives the original full size.
    @ingroup faces
    
*/
typedef int32_t IFR_CREATE_FACE_FLAGS;
/*! @cond DONTDOXYCOMMENT */
static const IFR_CREATE_FACE_FLAGS IFR_CREATE_FACE_FLAGS_NONE = 0;                
static const IFR_CREATE_FACE_FLAGS IFR_FACE_PRE_COMPUTE_HIGH = (1 << 1);          
static const IFR_CREATE_FACE_FLAGS IFR_FACE_PRE_COMPUTE_FEATURESET_96 = (1 << 1); 
static const IFR_CREATE_FACE_FLAGS IFR_FACE_PRE_COMPUTE_MED = (1 << 2);           
static const IFR_CREATE_FACE_FLAGS IFR_FACE_PRE_COMPUTE_LOW = (1 << 3);           
static const IFR_CREATE_FACE_FLAGS IFR_FACE_PRE_COMPUTE_FEATURESET_48 = (1 << 3); 
static const IFR_CREATE_FACE_FLAGS IFR_FACE_ASPECT_REFINE = (1 << 4);             
static const IFR_CREATE_FACE_FLAGS IFR_FACE_IMAGE_NO_RESIZE = (1 << 5);
/*! @endcond */

/*! @cond DONTDOXYCOMMENT */
typedef int32_t IFR_ALIGN_METHOD;
static const IFR_ALIGN_METHOD IFR_ALIGN_METHOD_NONE = (1 << 0);   ///< Empty Flag
static const IFR_ALIGN_METHOD IFR_ALIGN_METHOD_SHIFT = (1 << 1);  ///< Use Shift Alignment @deprecated, use the Face Detectior with labeling and create the face from the result
static const IFR_ALIGN_METHOD IFR_ALIGN_METHOD_ROTATE = (1 << 2); ///< Use Rotate Alignment @deprecated, use the Face Detectior with labeling and create the face from the result
static const IFR_ALIGN_METHOD IFR_ALIGN_METHOD_ASPECT = (1 << 3); ///< Use Aspect Alignment @deprecated, use the Face Detectior with labeling and create the face from the result
/*! @endcond */


typedef int32_t IFR_MASTERSLAVE_FLAGS;
static const IFR_MASTERSLAVE_FLAGS IFR_MASTERSLAVE_FLAGS_NONE = 0;
static const IFR_MASTERSLAVE_FLAGS IFR_MASTERSLAVE_WIPE_CURRENT_CONTENTS = (1 << 0);

/*! @brief Flags to control how the face detector works
 Flag                               |   Meaning
------------------------------------|----------------------------------   
IFR_DETECTION_SIMPLE                | Use the default vertical only face detector
IFR_DETECTION_ROTATE                | Rotate the input image between -50 and 50 degrees (slow)
IFR_DETECTION_NONE                  | Dont detect any faces, can be useful as the images using the same detector handle are returned in calling order to control how many frames of a video have the face detector run against it without changing the orrder
IFR_DETECTION_LARGEST               | Return only the largest face in the image
IFR_DETECTION_LABEL                 | Run the face labeller to return accurate eye locations (THIS SHOULD BE THE DEFAULT)
IFR_DETECTION_FACENESS				| Run the Faceness checker within the detector. This removes many ~95% false positive faces, this is slower and may not run at video framerates
IFR_DETECTION_PREDICTION            | This flag is not passed to the face detector, but can be set in the trackers  if prediction is enabled, it means the detections on that image were predicted by tracking and not face detected
IFR_DETECTION_EXPERIMENTAL          | This flag turns on the Expermental face detector
IFR_DETECTION_EXTERNAL				| This flag is used if the detection was passed in by a third party detector
   
    @ingroup facedetection
     */
typedef int32_t IFR_DETECTION_FLAGS;
/*! @cond DONTDOXYCOMMENT */
static const IFR_DETECTION_FLAGS IFR_DETECTION_SIMPLE = 0;             
static const IFR_DETECTION_FLAGS IFR_DETECTION_ROTATE = (1 << 0);      
static const IFR_DETECTION_FLAGS IFR_DETECTION_NONE = (1 << 1);        
static const IFR_DETECTION_FLAGS IFR_DETECTION_LARGEST = (1 << 2);     
static const IFR_DETECTION_FLAGS IFR_DETECTION_LABEL = (1 << 3);       
static const IFR_DETECTION_FLAGS IFR_DETECTION_PREDICTION = (1 << 4);  
static const IFR_DETECTION_FLAGS IFR_DETECTION_EXPERIMENTAL = (1 << 5);
static const IFR_DETECTION_FLAGS IFR_DETECTION_EXTERNAL = (1 << 6);
static const IFR_DETECTION_FLAGS IFR_DETECTION_FACENESS = (1 << 7);

/*! @endcond */


/*! @cond DONTDOXYCOMMENT */
typedef IFR_UUID IFR_TRACKID;
/*! @endcond DONTDOXYCOMMENT */

/*! The type of object a uuid refers to */
typedef enum IFR_UUID_TYPE {
    IFR_PERSON_UUID = 1,        ///< A Person @sa #ifr_SavePerson
    IFR_ENROLMENT_UUID = 2,     ///< An Enrolment @sa #ifr_EnrolFaceList
    IFR_FACE_UUID = 3,          ///< A Face
    IFR_FEATURES_UUID = 4,      ///< A Model
    IFR_TRACKLET_UUID = 5,      ///< A Tracklet
    IFR_REGION_UUID = 6,        ///< A Region
    IFR_ALERT_UUID = 7,         ///< An Alert
    IFR_ALERTINSTANCE_UUID = 8, ///< An instance of an alert
    IFR_TRACK_UUID = 9,         ///< A Track
    IFR_LOCATION_UUID = 10,     ///< A Location
    IFR_TARGET_UUID = 11,       /// An Alert Target
    IFR_VIDEOSOURCE_UUID = 12,  ///< A Video Source
} IFR_UUID_TYPE;

//typedef void* IFR_HANDLE;							///< A generic type for any handle.

typedef struct IFR_CONTEXT IFR_CONTEXT;  ///< A database connection object.
typedef IFR_CONTEXT *IFR_CONTEXT_HANDLE; ///< A handle to a database connection object.

typedef struct IFR_IMAGE IFR_IMAGE;  ///< An image object.
typedef IFR_IMAGE *IFR_IMAGE_HANDLE; ///< A handle to an image object.

typedef struct IFR_FACE IFR_FACE;         ///< A face object.
typedef IFR_FACE *IFR_FACE_HANDLE;        ///< A handle to a face object.
typedef const IFR_FACE *IFR_FACE_CHANDLE; ///<  constant handle to a face object.

typedef struct IFR_PERSON IFR_PERSON;  ///< A person object.
typedef IFR_PERSON *IFR_PERSON_HANDLE; ///< A handle to an person object.

typedef struct IFR_FACELIST IFR_FACELIST;         ///< A facelist object.
typedef IFR_FACELIST *IFR_FACELIST_HANDLE;        ///< A handle to a facelist object.
typedef const IFR_FACELIST *IFR_FACELIST_CHANDLE; ///< A constant handle to a facelist object.

typedef struct IFR_SEARCH IFR_SEARCH;  ///< A search object.
typedef IFR_SEARCH *IFR_SEARCH_HANDLE; ///< A handle to a search object.

typedef struct IFR_VERIFY IFR_VERIFY;  ///< A verification object.
typedef IFR_VERIFY *IFR_VERIFY_HANDLE; ///< A handle to a verification object.

typedef struct IFR_DETECTOR IFR_DETECTOR;  ///< A detector object.
typedef IFR_DETECTOR *IFR_DETECTOR_HANDLE; ///< A handle to a detector object.

typedef struct IFR_DETECTOR_RESULT IFR_DETECTOR_RESULT;  ///< A detector result object.
typedef IFR_DETECTOR_RESULT *IFR_DETECTOR_RESULT_HANDLE; ///< A handle to a detector result object.

typedef struct IFR_MODEL IFR_MODEL;  ///< A Model Object
typedef IFR_MODEL *IFR_MODEL_HANDLE; ///< A Handle to a Model Object

typedef struct IFR_MODELDATA IFR_MODELDATA;  ///< A Model Data Object
typedef IFR_MODELDATA *IFR_MODELDATA_HANDLE; ///< A Handle to a Model Data Object

typedef struct IFR_SEARCH_RESULTS IFR_SEARCH_RESULTS;  ///< A Search Results Object
typedef IFR_SEARCH_RESULTS *IFR_SEARCH_RESULTS_HANDLE; ///< A Handle to a Search Results Object

typedef struct IFR_PERSONEXPORT IFR_PERSONEXPORT;  ///< An object used to hold an entire person record used in exporting and importing
typedef IFR_PERSONEXPORT *IFR_PERSONEXPORT_HANDLE; ///< A Handle to a person export record

typedef struct IFR_FACETRACKER IFR_FACETRACKER;  ///< A Face Tracker object.
typedef IFR_FACETRACKER *IFR_FACETRACKER_HANDLE; ///< A handle to a Face Tracker object.

typedef struct IFR_TRACKLET IFR_TRACKLET;  ///< a Face Tracker object.
typedef IFR_TRACKLET *IFR_TRACKLET_HANDLE; ///< A handle to an Tracklet object.

typedef struct IFR_TRACKLETBUFFER IFR_TRACKLETBUFFER;  ///< A Tracklet Buffer object.
typedef IFR_TRACKLETBUFFER *IFR_TRACKLETBUFFER_HANDLE; ///< A handle to an Tracklet Buffer object.

typedef struct IFR_TRACKLETBUFFERSEARCHRESULTS IFR_TRACKLETBUFFERSEARCHRESULTS;  ///< A Tracklet Buffer search results object.
typedef IFR_TRACKLETBUFFERSEARCHRESULTS *IFR_TRACKLETBUFFERSEARCHRESULTS_HANDLE; ///< A handle to an Tracklet Buffer Search Results object.



typedef struct IFR_DISPLAY IFR_DISPLAY; //!< A HAndle to a display window (if included in SDK)
typedef IFR_DISPLAY *IFR_DISPLAY_HANDLE;


//! @struct IFR_DISTANCERESULT
//! @ingroup search
//! @brief  A single result from the search.
//! @note personName is only guaranteed valid as long as the object that returned the #IFR_DISTANCERESULT still exists.

typedef struct IFR_DISTANCERESULT
{
    float distance;         ///< Result distance. The lower the better A value of 0 indicates a perfect match and only occurs when testing an image against itself.
    IFR_UUID enrolmentId;   ///< Unique ID of the enrolment that matched.
    IFR_UUID personId;      ///< Unique ID of the person.
    int64_t matchQuality;   ///< Quaility of the match. A number between 1 and 3. A match quality of 1 is determined by us to be a strong match, 2 a weak match, and 3 means we have no confidence in the result.
    const char *personName; ///< The name string associated with the personId. this is guaranteed valid only as long as the object that returned the IFR_DISTANCERESULT result is unchanged.
    float margin;           ///< The difference between this and the next (unique person) result( even if that result does not appear in the result list as it may be filtered)
	float probability;		///< If this is positive, it is the probability that the result is the correct match, only available for IFRV2 searches.
} IFR_DISTANCERESULT;

//! @ingroup facedetection
//! A single result from the face detection.
typedef struct IFR_DETECTORRESULT
{
    IFR_EYES eyes;              ///< The Eye locations detected. These are only as accurate as the mode the detector was caled in
    float quality;              ///< a relative metric which describes how well the face is aligned and looking forwards, this only makes sense if the image is actually a face, a false detection may have a high quality even though it is not a face, higher is better, a very good face is 0.002 ok is 0.001
    IFR_UUID track_id;          ///< a track identifier which is set only if the tracker produced the detection, faces from multiple frames of a video which the tracker tracked are given the same id.
    IFR_POINT_PAIR mouth;       ///< a pair of coordinates which approximates the edges of the mouth.
    IFR_DETECTION_FLAGS flags;  ///< The detector flags that were in place when the detection was made
    float landmark_var;         ///< the landmark variance, this is a metric the attempts to detect if the image is a face, anything below 0.37 is very likely to be a real face any thing above 0.5 is unlikely to be a face,
    IFR_POINT *landmark_points; ///< an array of points which were used to calculate variance. This is only guaranteed to be valid which the #IFR_DETECTOR_RESULT_HANDLE that supplied the #IFR_DETECTORRESULT still exists
    size_t numPoints;           ///< The numebr of points in #landmark_points.
	float faceness;				///< measure the face likelyhood for the image to filter out non-faces. 
    int64_t int_track_id;             ///< a track identifier which is only unique for the tracker instance, if you can, use the uuid version as that is unique across all face detectors
} IFR_DETECTORRESULT;


//! @brief Esitmated life status of face tracked ( Experimental) .
/*! In the track history record we try to determine if the face we are tracking is a real live person.
	This may be used to try to help detect spoofing, though there are possibly ways to fake it.
*/
typedef enum IFR_LIFESTATE
{
	INDETERMINATE = 0,
	LIVING = 1,
	DEAD = 2
} IFR_LIFESTATE;

//! @ingroup tracks
//! A single record showing the location of a face a a specific time within a track
typedef struct IFR_TRACK_HISTORY_RECORD
{
    IFR_POINT centre;     ///< The centrepoint of the face
    size_t radius;        ///< The radius of the face
    float angle;          ///< The angle of the face
    IFR_EYES eyes;        ///< The eye locations
    IFR_POINT_PAIR mouth; ///< The mouth edge locations
    IFR_TIME timeStamp;   ///< The time that the record refers to
    IFR_LIFESTATE alive;  ///< estimated lifestate -- experimental
} IFR_TRACK_HISTORY_RECORD;

//! @ingroup tracks
//! @brief  A single result from a serach of a #IFR_TRACKLETBUFFER.
typedef struct IFR_BUFFER_SEARCH_RESULT
{
    float distance;      ///< Result distance. The lower the better A value of 0 indicates a perfect match and only occurs when testing an image against itself.
    IFR_UUID trackId;    ///< The Track ID which produced the result
    IFR_UUID trackletId; ///< The specific Tracklet ID which produced the result
    IFR_TIME startTime;  ///< The start time of the tracklet
    IFR_TIME endTime;    ///< The entime of the tracklet
    IFR_UUID location;   ///< The identifier of the location the tracklet came from
    int count;           ///< number of results merged into this result, distance = totalDistace / count
    float totalDistance; ///< The combined distance of the individual tracklet results, when multiple tracklets have been merged to a single track
} IFR_BUFFER_SEARCH_RESULT;

//! A struct containing the statistics of a search
typedef struct IFR_STATS
{
    size_t sample_size; ///< The number of samples included
    float mean;         ///< The mean result`
    float std_dev;      ///< the Standard deviation
    float min;          ///< the minimum result
    float max;          ///< the maximum result
} IFR_STATS;



/*! @brief Flags which contain the results of spoof checking
Flag                              |   Meaning
----------------------------------|----------------------------------
IFR_SPOOF_NOTAVAILABLE            | Spoof checking not available on this device
@ingroup face
*/
typedef int32_t IFR_SPOOF_FLAGS;
static const IFR_SPOOF_FLAGS IFR_SPOOF_NOTAVAILABLE = 0x01; ///< Spoofing is not avaliable


//! A struct containing the results of spoof checking, requires a 3d sensor.
//! @ingroup face
typedef struct IFR_SPOOF_CHECKS
{
	IFR_SPOOF_FLAGS flags;
	float dist;
	float aspect_ratio;
	float face_size;
	float plane;
	float face3D;
	float face_var;
} IFR_SPOOF_CHECKS;

//! Completion routine function definitions
typedef void (*IFR_CompletionRoutine)(IFR_RETURN, void *);                                                                        ///< Basic completion routine for functions with no results.
typedef void (*IFR_FaceRecCompletionRoutine)(IFR_RETURN, IFR_CONTEXT_HANDLE, void *);                                             ///< Callback function for when the #ifr_CreateFaceRec finishes. 
typedef void (*IFR_ProgressRoutine)(void *, float, const char *);                                                                 ///< Callback function for  progress.
typedef void (*IFR_ProgressRoutine2)(IFR_RETURN, float, const char *, void *);                                                     ///< Callback function for  progress, incuding the final result
typedef void (*IFR_PersonCompletionRoutine)(IFR_RETURN, IFR_PERSON_HANDLE, void *);                                               ///< Callback function for when the #ifr_SavePerson finishes. 
typedef void (*IFR_ResultIdsCompletionRoutine)(IFR_RETURN, IFR_RESULTIDS *, void *);                                              ///< Callback function for when the #ifr_FindPersonByName finishes. 
typedef void (*IFR_FaceListCompletionRoutine)(IFR_RETURN, IFR_FACELIST_HANDLE, void *);                                           ///< Callback function for when the #ifr_LoadFaceList finishes. 
typedef void (*IFR_FaceCompletionRoutine)(IFR_RETURN, IFR_FACE_HANDLE, void *);                                                   ///< Callback function for when the #ifr_LoadFace finishes. 
typedef void (*IFR_SearchCompletionRoutine)(IFR_RETURN, IFR_SEARCH_HANDLE, void *);                                               ///< Callback function for when the #ifr_Search finishes.
typedef void (*IFR_Search2CompletionRoutine)(IFR_RETURN, IFR_SEARCH_RESULTS_HANDLE, void *);                                      ///< Callback function for when the #ifr_Search2 finishes.
typedef void (*IFR_DetectionCompletionRoutine)(IFR_RETURN, IFR_DETECTOR_RESULT_HANDLE, void *);                                   ///< Callback function for when the ifr_DetectFacesInImage(), ifr_DetectFacesInImage2() functions finish.
typedef void (*IFR_UInt32CompletionRoutine)(IFR_RETURN, uint32_t, void *);                                                        ///< Callback function for when the #ifr_CountPeople,#ifr_CountImages finishes.
typedef void (*IFR_Int64CompletionRoutine)(IFR_RETURN, int64_t, void *);                                                          ///< Callback function for when and int64_t needs to be returned. 
typedef void (*IFR_EnrolFaceListCompletionRoutine)(IFR_RETURN, IFR_FACELIST_HANDLE, IFR_UUID, void *);                            ///< Callback function for when the #ifr_EnrolFaceList finishes. 
typedef void (*IFR_UUIDCompletionRoutine)(IFR_RETURN, IFR_UUID, void *);                                                          ///< Callback function for when the #ifr_EnrolFaceList2 finishes. 
typedef void (*IFR_StringsCompletionRoutine)(IFR_RETURN, IFR_STRINGS_HANDLE, void *);                                             ///< Callback function for when the #ifr_GetKnownTags finishes. 
typedef void (*IFR_VerifyCompletionRoutine)(IFR_RETURN, IFR_VERIFY_HANDLE, void *);                                               ///< Callback function for when the #ifr_Verify finishes.
#ifndef SWIG
typedef void (*IFR_TrackerCallbackRoutine)(IFR_UUID, IFR_UUID, enum IFR_TRACKER_EVENT, IFR_TRACKID, IFR_TIME, IFR_TRACKLET_HANDLE, void *); ///< Callback function for when an interesting thing happens to a track in a tracker region.
#endif //SWIG
typedef void (*IFR_ParameterUpdateRoutine)(const char *, void *);                                                                 ///< Callback for when a paramter is changed.
typedef void (*IFR_HandleCompletionRoutine)(IFR_RETURN, IFR_HANDLE, void *);                                                      ///< Callback function for when the any item that returns a handle finishes.

#ifdef __cplusplus
} //extern "C"
#endif

#endif //__IMAGUS_FACE_DEFINITIONS__
