/* 
 * Copyright 2021 NXP  
 * NXP Confidential. This software is owned or controlled by NXP and may only be 
 * used strictly in accordance with the applicable license terms. By expressly 
 * accepting such terms or by downloading, installing, activating and/or otherwise
 * using the software, you are agreeing that you have read, and that you agree to
 * comply with and are bound by, such license terms.  If you do not agree to be 
 * bound by the applicable license terms, then you may not retain, install, 
 * activate or otherwise use the software.
 * 
 */


/**********************************************************************************************************************
 *   Project              : RFE_SW
 *   Platform             : SAF85xx/SAF86xx/TEF83xx
 *********************************************************************************************************************/
//<One Empty Line here: Applicable to all other sections>
/* 
 * Info: include guard is derived from file name, if file name is rfeApi.h then include guard will be RFE_API_H.
 */
#ifndef RFE_EXAMPLE_API_H 
#define RFE_EXAMPLE_API_H
//<Two Empty Lines here - Line 0: Applicable to all other sections>
//<Two Empty Lines here - Line 1: Applicable to all other sections>
/**********************************************************************************************************************
 *                                                         INCLUDES
 *********************************************************************************************************************/
#include <stdint.h>


/**********************************************************************************************************************
 * FILE VERSION INFORMATION <Used only for header files exposing interfaces to external entity>
 *********************************************************************************************************************/



/**********************************************************************************************************************
 *                                                         TYPES
 *********************************************************************************************************************/

/** <add details here> */
#define RFE_EXAMPLE_API    ( ( unit32_t ) 10ul )
//<Two Empty Lines here - Line 0: Applicable to similar cases>
//<Two Empty Lines here - Line 1: Applicable to similar cases>
//Though different styles of documentation is possible, its preferable to use postfix way shown further in this file.
/**
 * Document Details of "rfeExampleApi_GrpPre_t" here.
 */
typedef enum
{
    /* Different styles of postfix documentation shown below. Please use any of these. */
    
    /** This is example One */
    rfeExampleApi_GrpPre_One_e,
    /// This is example Two
    rfeExampleApi_GrpPre_Two_e,
    /*! This is example Three */
    rfeExampleApi_GrpPre_Three_e,  
    //! This is example Four
    rfeExampleApi_GrpPre_Four_e    
} rfeExampleApi_GrpPre_t;


/**
 * Document Details of "rfeExampleApi_GrpPost_t" here.
 */
typedef enum
{
    /* Different styles of postfix documentation shown below. Please use any of these. */
      
    rfeExampleApi_GrpPost_Five_e = 5ul,   /*!< This is example Five */
    rfeExampleApi_GrpPost_Six_e,          ///< This is example Six
    rfeExampleApi_GrpPost_Seven_e,        /*!< This is example Seven */
    rfeExampleApi_GrpPost_Eight_e,        /**< This is example Eight */
    rfeExampleApi_GrpPost_Nine_e,         //!< This is example Nine
    rfeExampleApi_GrpPost_Ten_e           /**< This is example Ten */    
} rfeExampleApi_GrpPost_t;


/**
 * This structure contains the radar cycle and chirp sequence count.
 * It can be retrieved via rfe_getRadarCycleCount().
 */
typedef struct
{
    /** Number of radar cycles that have been completed since rfe_radarCycleStart() . */
    uint32_t radarCycleCount;
    /** Number of chirp sequences that have been completed since rfe_radarCycleStart() . */
    uint32_t chirpSequenceCount;
} rfe_radarCycleCount_t;


/**********************************************************************************************************************
 *                                                         FUNCTIONS
 *********************************************************************************************************************/
 
/**
 * \brief   <add details of the function>
 * 
 * \details < add details of the function>  
 * 
 * \pre    <add precondition here, if no precondition exists then add the text "NIL" >
 * 
 * \param [in]          <add input parameter here>                  <add details of the parameter here> 
 * \param [out]         <add output parameter here>                 <add details of the parameter here> 
 * \param [in, out]     <add in-out parameter here>                 <add details of the parameter here> 
 * \param [in, out]     RFE_ERROR_FUNCTION_PARAMETER                Error handling parameter:
 * 
 * \return <add return information, example: On success return #RFE_API_SUCCESS, on failure #RFE_API_FAILURE >
 * 
 * \post  <add postcondition here, if postcondition does not exists then add the text "NIL" >
 * 
 * \ingroup <add the tag used for grouping, example: interrupt_sources>
 */
void rfeExampleApi_enable_func_int_tx(
    <input param>,
    <output param> 
);
//<Two Empty Lines here - Line 0: Applicable to similar cases>
//<Two Empty Lines here - Line 1: Applicable to similar cases>
/* 
 * Note: 
 * 1. If a function has to be referred in documentation use the following format "funcName()".
 * 2. It is not mandatory to use all the tags if user of the API does not benefit from it.
 *
 */
#endif // !RFE_EXAMPLE_API_H
//<One Empty Line here>