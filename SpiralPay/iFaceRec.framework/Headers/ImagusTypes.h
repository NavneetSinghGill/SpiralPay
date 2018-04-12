//!
//! @file    ImagusTypes.h
//!
//!
//!            Copyright (c) 2016 Imagus. All rights reserved.
//!
#if !defined __IMAGUS_TYPE_DEFINITIONS__
#define __IMAGUS_TYPE_DEFINITIONS__

#include <stddef.h>
#include <stdint.h>
#include <string.h>


#ifdef __cplusplus
extern "C" {
#endif
/*!  @brief Universally unique identifier

These are used as identifiers in the database

@sa
    #ifr_CharToUUID
    #ifr_GenerateNullUUID
    #ifr_UUIDToChar2
    #ifr_GenerateUUID
@ingroup UUID
 */
typedef struct IFR_UUID
{
    /*! a union of different array types totallying 16 bytes so that each individual byte of the UUID may be accessed in multiple ways*/
    union
    {
        uint64_t u64[2]; //!< 	2 64-bit integer type
        uint32_t u32[4]; //!< 	4 32-bit integer type
        uint16_t u16[8]; //!< 	8 16-bit integer type
        uint8_t u8[16];  //!< 	16 8-bit integer type
    } types;

} IFR_UUID;

/*!
 @brief Returns codes for the API.
 For errors the return codes are negative. */
typedef enum IFR_RETURN {
    IFR_SUCCESS = 1,                     //!< The function completed succesfully
    IFR_DEFERRED = 2,                    //!< The function has not yet completed.
    IFR_TRUE = 3,                        //!< The function completed succesfully and returned true
    IFR_FALSE = 4,                       //!< The function completed succesfully and returned false errors are negative numbers
    IFR_EXPIRED = -1,                    //!< The licence has expired.
    IFR_LICENCE_ERROR = -2,              //!< The licence key is not valid, or you are trying to use a feature not enabled by your licence.
    IFR_DATABASE_ERROR = -3,             //!< Error accessing the database.
    IFR_MAX_IMAGES_ERROR = -4,           //!< Attempt to add more than the maximum allowed number of images.
    IFR_IMAGE_ERROR = -5,                //!< Error processing the supplied image.
    IFR_INVALID_ID = -6,                 //!< The ID supplied is not valid/ does not exist.
    IFR_ARGUMENT_ERROR = -9,             //!< Returned when an invalid argument has been supplied.
    IFR_FACE_QUALITY_TOO_LOW = -10,      //!< None of the faces meet the quality threshold.
    IFR_NOT_IMPLEMENTED = -11,           //!< This function has not been implemented.
    IFR_UNKNOWN_CONTEXT = -12,           //!< the context used is not known.
    IFR_UNKNOWN_ERROR = -13,             //!< An unknown Error Occurred
    IFR_INVALID_PTR = -14,               //!< An invalid pointer was passed to a 'destroy' function
    IFR_SAVE_ERROR = -15,                //!< Error occured when saving image
    IFR_DATABASE_UPGRADE_REQUIRED = -16, //!< The database reuqires an upgrade to operate with this software version
    IFR_DATABASE_VERSION_TOO_HIGH = -17, //!< The database version is too high to operate with this software version
    IFR_ALREADY_INITIALISED = -18,       //!< The API has already been initialised.
    IFR_NOT_INITIALISED = -19,           //!< Shutdown was called when the API had not been initialised.
    IFR_NETWORK_ERROR = -20,             //!< A Networking error occured, this may be a disconnected form a remote worker, etc.
    IFR_INVALID_PATH = -21,              //!< A Path supplied is invalid in the context of the function
    IFR_CANCELLED = -22,                 //!< The function was cancelled before it was completed.
    IFR_INVALID_SIZE = -23,              //!< An invalid size was supplied
    IFR_UNAUTHORISED = -24,              //!< an authorisation attempt failed;
    IFR_BAD_CONFIDENCE_MEASURES = -25,   //!< The confidence measures supplied are incorrect, rejectDistance should be higher than acceptDistance, and high margin should be higher than low margin;
    IFR_INVALID_PARAMETER = -26,         //!< The parameter name / type combination does not exist for this handle
    IFR_INVALID_HANDLE = -27,            //!< the handle supplied is not valid for the function
    IFR_TIMEOUT = -28,                   //!< A Timeout has occured
    IFR_INTERNAL_LOGIC_ERROR = -29,      //!< An internal problem has occured, please produce a minimal reporduction and send to Imagus
    IFR_INVALID_PARAMETER_TYPE = -30,    //!< The parameter type is not valid for this parameter name.
    IFR_READONLY_PARAMETER = -31,        //!< The parameter is not writeable
    IFR_WRITEONLY_PARAMETER = -32,       //!< You cannot read this parameter, only write to it
    IFR_INVALID_ALGORITHM = -33,         //!< an invalid algortihm type was supplied
    IFR_BAD_FILE = -34,                  //!< The file supplied is not valid
    IFR_INDEX_OUT_OF_BOUNDS = -35,       //!< the index supplied is out of bounds
    IFR_PARAMETER_OUT_OF_RANGE = -36,    //!< The parameter is not within required bounds
	IFR_NOT_CLUSTERED = -37,					//<! images are not compeletely clustered. Please apply recluster
	IFR_INVALID_DATABASE_FOR_SCHEMA = -38,		//<! The Database type requested cannot support a schema
    IFR_CANNOT_WRITE_TO_FILE = -39,				//<! Cannot write to specified file
    IFR_UNSUPPORTED_HARDWARE = -40              //<! Hardware is not supported by this product
} IFR_RETURN;

#define IFR_DEFERED IFR_DEFERRED //! macro fixes a spelling mistake.

#define IFR_SUCCEEDED(ErrorCode) \
    (((IFR_RETURN)ErrorCode) > 0) ///< Macro to test for a return success.
#define IFR_FAILED(ErrorCode) \
    (((IFR_RETURN)ErrorCode) < 0) ///< Macro to test for a return failure.

/*!

 @brief Memory leak flags to control memory leak detection
 @sa #ifr_SetLeakDetector, #ifr_CountLeaks
 @ingroup leaks
*/
typedef enum IFR_LEAK {
    IFR_LEAK_RESET = 1, ///< Reset/enable the leak detection counts, this will
    /// forget any objects already counted, and start again
    IFR_LEAK_OFF = 0, ///< Turns the leak detection off, #ifr_CountLeaks can be
                      /// called after this to display the latest counts
} IFR_LEAK;

/*!
The UTC time in milliseconds since 1970-01-01 00:00:00...

use the constant #IFR_DATETIMENOW to set the current server time as the time of
creation

use #IFR_DATETIMEUNKNOWN to set the time as unknown,

if set to >=0 <= 500,000,000,000 ( 500 billion milliseconds, ~16 years )

then the time stamp is an arbritray time stamp relative to an unknown epoch. (
usually the start of a video file).
@ingroup time
@{
*/
typedef int64_t IFR_TIME;
static const IFR_TIME IFR_DATETIMENOW = -1;         /*!<  used in some method to denote  the current time*/
static const IFR_TIME IFR_DATETIMEUNKNOWN = 0;      /*!<  unknown time */
static const IFR_TIME IFR_MINTIME = 500000000000LL; /*!<  the minimum time, in video playback anything lower  that this is considered offset from 0 */
/*! @} */

/*! The Type of Parameter
@ingroup params
@{*/
typedef enum IFR_VARTYPE {
    IFR_VARTYPE_UNKNOWN = 0,
    IFR_STRING = 1,
    IFR_INT = 2,
    IFR_FLOAT = 3,
    IFR_VAR_TIME = 4,
    IFR_CHOICE = 5
} IFR_VARTYPE;
/*! @} */

/*!

 @brief  A rectangle struct.
  A struct containing pixel coordinates for top-left and bottom-right corners of
 the rectangle.
 @b left and @b top refer to the top-left corner (x,y) coordinates respectively,
 @b right and @b bottom refer to the bottom-right (x,y) coordinates,
 respectively.
 @ingroup coords
 */
typedef struct IFR_RECT
{
    uint32_t left;   ///< Left corner in pixels (x)
    uint32_t top;    ///< Top corner in pixels (y)
    uint32_t right;  ///< Right corner in pixels (x)
    uint32_t bottom; ///< Bottom corner in pixels (y)
} IFR_RECT;

/*!

@brief  A Point  struct.
 A struct containing pixel coordinates.
@ingroup coords
*/
typedef struct IFR_POINT
{
    float X;
    float Y;

} IFR_POINT;


//! @brief  A struct which hold co-ordinate data for eye locations
/*! A struct containing pixel coordinates for left eye and right eyes.
@b left.X and @b left.X refer to the co-ordinates of the persons left eye,
@b right.X and @b right.Y refer to the co-ordinates of the persons right eye,
Note if the person is right side up on and front facing the left eyes
co-ordinates will to the right hand side of the image
if the person is upside down the left eye co-ordinates will be towards the left
of the image.
@ingroup coords
*/
typedef struct IFR_EYES
{
    IFR_POINT left;  ///< co-ordinate of Left Eye in image
    IFR_POINT right; ///< co-ordinate of Right Eye in image
} IFR_EYES;
typedef IFR_EYES IFR_POINT_PAIR;
/*! A floating point version of a rectangle
  @ingroup coords
  */
typedef struct IFR_RECT_FLOAT
{
    IFR_POINT centre; ///< The Centre point of the rectangle
    float width;      ///< the width
    float height;     ///< the height
} IFR_RECT_FLOAT;

/*! This contains the definition of a parameter which can be configured on certain
handle types.
These parameters are not neceserily available on all instances of the handle.
For example a handle pointing to a one video source, may have the ability to
request a resolution, the second may require a password etc.

@ingroup params
*/
typedef struct IFR_PARAMETER
{
    const char *name; ///< this is guaranteed valid only as long as the object  that returned the IFR_PARAMETER exists and is unchanged
    IFR_VARTYPE type; ///< Type of the parameter
    int32_t readonly; ///< if > 0 then parameter is readonly and cannot be changed;
    int32_t options;  ///< if Not 0 then parameter has a list of options attached called name_options
} IFR_PARAMETER;

/*!  @brief Direction to move in, either forward or backward. 
*/
typedef enum IFR_DIRECTION {
    IFR_FWD = 0, ///< Search directon forward.
    IFR_BKD = 1, ///< Search directon backward.
} IFR_DIRECTION;

typedef struct IFR_RESULTIDS IFR_RESULTIDS;  //!< A result IDs object.
typedef IFR_RESULTIDS *IFR_RESULTIDS_HANDLE; //!< A handle to an result IDs object, this is a vector of uuids

typedef struct IFR_CALLBACK IFR_CALLBACK;  //!< A callback handle object
typedef IFR_CALLBACK *IFR_CALLBACK_HANDLE; //!< a callback handle, when you have registered a callback, look after this object, and delete it when you want to unregister the callback.

typedef struct IFR_STRINGS IFR_STRINGS;
typedef IFR_STRINGS *IFR_STRINGS_HANDLE; //!< A handle to an result IDs object, this is a vector of strings

typedef struct IFR_PARAMETERLIST IFR_PARAMETERLIST;  //!< a  this is a vector of #IFR_PARAMETER  structs @ingroup params
typedef IFR_PARAMETERLIST *IFR_PARAMETERLIST_HANDLE; //!< A handle to a #IFR_PARAMETERLIST, this is a vector of #IFR_PARAMETER  structs @ingroup params

typedef struct IFR_INTS IFR_INTS;  //!<  this is a vector of ints
typedef IFR_INTS *IFR_INTS_HANDLE; //!< A handle to a #IFR_INTS, this is a vector of ints

typedef struct IFR_FLOATS IFR_FLOATS;  //!<  this is a vector of floats
typedef IFR_FLOATS *IFR_FLOATS_HANDLE; //!< A handle to a #IFR_FLOATS, this is a vector of ints


typedef struct IFR_BUFFER IFR_BUFFER;  //!< This is a databuffer which abstracts away any buffer type, along with an optional associated free function
typedef IFR_BUFFER *IFR_BUFFER_HANDLE; //!< A handle to a #IFR_BUFFER

typedef struct IFR_TAG_EXPRESSION IFR_TAG_EXPRESSION; //!< A Tag Expression used for filtering queries by tag
typedef IFR_TAG_EXPRESSION *IFR_TAG_EXPRESSION_HANDLE;

#define IFR_HANDLE void * //!< A all handle type to show when a function can take any HANDLE type

#ifdef __cplusplus
} // extern "C"

static const IFR_UUID NullUUID = {{{0}}};

inline bool operator==(IFR_UUID const &lhs, IFR_UUID const &rhs)
{
    return memcmp(&lhs.types.u8[0], &rhs.types.u8[0], sizeof(lhs)) == 0;
}

inline bool operator!=(IFR_UUID const &lhs, IFR_UUID const &rhs)
{
    return !(lhs == rhs);
}

inline bool operator>(IFR_UUID const &lhs, IFR_UUID const &rhs)
{
    return memcmp(&lhs.types.u8[0], &rhs.types.u8[0], sizeof(lhs)) > 0;
}

inline bool operator<(IFR_UUID const &lhs, IFR_UUID const &rhs)
{
    return (rhs > lhs);
}

inline bool operator<=(IFR_UUID const &lhs, IFR_UUID const &rhs)
{
    return !(lhs > rhs);
}

inline bool operator>=(IFR_UUID const &lhs, IFR_UUID const &rhs)
{
    return !(rhs > lhs);
}

#else
/*! A Macro which  initialises an #IFR_UUID to null @ingroup UUID */
#define ZERO_UUID(_u)        \
    {                        \
        _u.types.u64[0] = 0; \
        _u.types.u64[1] = 0; \
    }

#endif

#endif //__IMAGUS_TYPE_DEFINITIONS__
