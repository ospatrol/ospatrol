/* @(#) $Id: ./src/win32/setup-syscheck.c, 2011/09/08 dcid Exp $
 */

/* Copyright (C) 2009 Trend Micro Inc.
 * All rights reserved.
 *
 * This program is a free software; you can redistribute it
 * and/or modify it under the terms of the GNU General Public
 * License (version 2) as published by the FSF - Free Software
 * Foundation
 */


#include "setup-shared.h"
#include "os_xml/os_xml.h"
#include "os_xml/os_xml_writer.h"

#define OSPATROL_CONFIG_TMP  ".tmp.ospatrol.conf"


/* Enable Syscheck.*/
int main(int argc, char **argv)
{
    char *status;
    char *(xml_syscheck_status[])={"ospatrol_config","syscheck","disabled", NULL};

    if(argc < 3)
    {
        printf("%s: Invalid syntax.\n", argv[0]);
        printf("Try: '%s <dir> [enable|disable]'\n\n", argv[0]);
        return(0);
    }

    /* Checking for directory. */
    if(chdir(argv[1]) != 0)
    {
        printf("%s: Invalid directory: '%s'.\n", argv[0], argv[1]);
        return(0);
    }


    /* Checking if ospatrol was installed already */
    if(!fileexist(OSPATROLCCONF))
    {
        printf("%s: OSPatrol not installed yet. Exiting.\n", argv[0]);
        return(0);
    }


    /* Checking status. */
    if(strcmp(argv[2], "enable") == 0)
    {
        status = "no";
    }
    else
    {
        status = "yes";
    }


    /* Writing to the XML. */
    if(OS_WriteXML(OSPATROLCONF, OSPATROL_CONFIG_TMP, xml_syscheck_status,
                   NULL, "no", status, 0) != 0)
    {
        printf("%s: Error writing to the Config file. Exiting.\n", argv[0]);
        return(0);
    }

    /* Renaming config files */
    unlink(OSPATROLLAST);
    rename(OSPATROLCONF, OSPATROLLAST);
    rename(OSPATROL_CONFIG_TMP, OSPATROLCONF);

    return(0);
}


/* EOF */
