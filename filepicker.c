#include "filepicker.h"

#ifndef __EMSCRIPTEN__
#include <nfd.h>
#else
#include <emscripten.h>
#endif
#include <stdio.h>
#include <stdlib.h>

c_filepicker_t *c_filepicker_new()
{
	c_filepicker_t *self = component_new("filepicker");
	return self;
}

#ifdef __EMSCRIPTEN__
EM_JS(void, call_alert, (), {
  alert('hello world!');
  throw 'all done';
});
#endif

static int c_filepicker_pick_save( c_filepicker_t *self, const char *filter,
		char **output)
{
	/* save dialog */
#ifndef __EMSCRIPTEN__
    nfdchar_t *outPath = NULL;
	nfdresult_t result = NFD_SaveDialog( filter, "resauces", &outPath );
    if(result == NFD_OKAY)
	{
		if (output) *output = outPath;
		return STOP;
    }
    else if(result == NFD_CANCEL)
	{
		if (output) *output = NULL;
    }
    else
	{
        printf("Error: %s\n", NFD_GetError() );
    }
	if (output) *output = NULL;
#endif
	return STOP;
}

static int c_filepicker_pick_load(c_filepicker_t *self, const char *filter,
		char **output)
{
#ifndef __EMSCRIPTEN__
    nfdchar_t *outPath = NULL;
    nfdresult_t result = NFD_OpenDialog( filter, "resauces", &outPath );
        
    if(result == NFD_OKAY)
	{
		if (output) *output = outPath;
		return STOP;
    }
    else if(result == NFD_CANCEL)
	{
		if (output) *output = NULL;
    }
    else
	{
        printf("Error: %s\n", NFD_GetError() );
    }
	if (output) *output = NULL;
#else
	call_alert();
#endif
    return STOP;
}

REG()
{
	ct_t *ct = ct_new("filepicker", sizeof(c_filepicker_t), NULL, NULL, 0);

	ct_listener(ct, WORLD, 100, sig("pick_file_save"), c_filepicker_pick_save);
	ct_listener(ct, WORLD, 100, sig("pick_file_load"), c_filepicker_pick_load);
}

