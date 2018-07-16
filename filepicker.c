#include "filepicker.h"

#include <nfd.h>
#include <stdio.h>
#include <stdlib.h>

c_filepicker_t *c_filepicker_new()
{
	c_filepicker_t *self = component_new("filepicker");
	return self;
}

static int c_filepicker_pick_file( c_filepicker_t *self, char **output)
{
    nfdchar_t *outPath = NULL;
    nfdresult_t result = NFD_OpenDialog( NULL, NULL, &outPath );
        
    if(result == NFD_OKAY)
	{
        puts("Success!");
        puts(outPath);
		*output = outPath;
		return STOP;
    }
    else if(result == NFD_CANCEL)
	{
        puts("User pressed cancel.");
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

	ct_listener(ct, WORLD, sig("pick_file"), c_filepicker_pick_file);
}

