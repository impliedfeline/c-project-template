/**
 * @file
 * @author impliedfeline
 * @date 11 May 2023
 * @brief File containing definitions used for greeting persons/parties.
 *
 * This module provides common greetings for use in situations where one may
 * have to provide a greeting to an interested party on the spot.
 */

#ifndef MODULE_H
#define MODULE_H

/**
 * @brief This function returns a friendly greeting.
 *
 * This function allocates memory equal to the amount of bytes in the
 * a static string that is compiled into the binary.
 *
 * @param greetee A string representing the person or party the greeting is to
 * be addressed to.
 * @return A friendly greeting.
 */
char *greeting(const char *greetee);

#endif
