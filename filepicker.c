#include "filepicker.h"

#include <nfd.h>
#include <stdio.h>
#include <stdlib.h>

c_filepicker_t *c_filepicker_new()
{
	c_filepicker_t *self = component_new("filepicker");
	return self;
}

static int c_filepicker_pick_save( c_filepicker_t *self, const char *filter,
		char **output)
{
	/* save dialog */
    nfdchar_t *outPath = NULL;
	nfdresult_t result = NFD_SaveDialog( filter, NULL, &outPath );
    if(result == NFD_OKAY)
	{
		*output = outPath;
		return STOP;
    }
    else if(result == NFD_CANCEL)
	{
		*output = NULL;
    }
    else
	{
        printf("Error: %s\n", NFD_GetError() );
    }
	*output = NULL;

	return STOP;
}

static int c_filepicker_pick_load( c_filepicker_t *self, const char *filter,
		char **output)
{
    nfdchar_t *outPath = NULL;
    nfdresult_t result = NFD_OpenDialog( filter, NULL, &outPath );
        
    if(result == NFD_OKAY)
	{
		*output = outPath;
		return STOP;
    }
    else if(result == NFD_CANCEL)
	{
		*output = NULL;
    }
    else
	{
        printf("Error: %s\n", NFD_GetError() );
    }
	*output = NULL;

    return STOP;
}

REG()
{
	ct_t *ct = ct_new("filepicker", sizeof(c_filepicker_t), NULL, NULL, 0);

	ct_listener(ct, WORLD | 100, sig("pick_file_save"), c_filepicker_pick_save);
	ct_listener(ct, WORLD | 100, sig("pick_file_load"), c_filepicker_pick_load);
}

