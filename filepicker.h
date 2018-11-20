#ifndef FILEPICKER_H
#define FILEPICKER_H

#include <ecs/ecm.h>

typedef float(*collider_cb)(c_t *self, vec3_t pos);
typedef float(*velocity_cb)(c_t *self, vec3_t pos);

typedef struct c_filepicker_t
{
	c_t super;
} c_filepicker_t;

DEF_CASTER("filepicker", c_filepicker, c_filepicker_t)

c_filepicker_t *c_filepicker_new(void);

#endif /* !FILEPICKER_H */
