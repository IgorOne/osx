`/* Helper function for repacking arrays.
   Copyright 2003 Free Software Foundation, Inc.
   Contributed by Paul Brook <paul@nowt.org>

This file is part of the GNU Fortran 95 runtime library (libgfor).

Libgfor is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

Ligbfor is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with libgfor; see the file COPYING.LIB.  If not,
write to the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
Boston, MA 02111-1307, USA.  */

#include "config.h"
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "libgfortran.h"'
include(iparm.m4)dnl

dnl Only the kind (ie size) is used to name the function.
void
`internal_unpack_'rtype_kind (rtype * d, const rtype_name * src)
{
  index_type count[GFC_MAX_DIMENSIONS - 1];
  index_type extent[GFC_MAX_DIMENSIONS - 1];
  index_type stride[GFC_MAX_DIMENSIONS - 1];
  index_type stride0;
  index_type dim;
  index_type dsize;
  rtype_name *dest;
  int n;

  dest = d->data;
  if (src == dest || !src)
    return;

  if (d->dim[0].stride == 0)
    d->dim[0].stride = 1;

  dim = GFC_DESCRIPTOR_RANK (d);
  dsize = 1;
  for (n = 0; n < dim; n++)
    {
      count[n] = 0;
      stride[n] = d->dim[n].stride;
      extent[n] = d->dim[n].ubound + 1 - d->dim[n].lbound;
      if (extent[n] <= 0)
        abort ();

      if (dsize == stride[n])
        dsize *= extent[n];
      else
        dsize = 0;
    }

  if (dsize != 0)
    {
      memcpy (dest, src, dsize * rtype_kind);
      return;
    }

  stride0 = stride[0];

  while (dest)
    {
      /* Copy the data.  */
      *dest = *(src++);
      /* Advance to the next element.  */
      dest += stride0;
      count[0]++;
      /* Advance to the next source element.  */
      n = 0;
      while (count[n] == extent[n])
        {
          /* When we get to the end of a dimension, reset it and increment
             the next dimension.  */
          count[n] = 0;
          /* We could precalculate these products, but this is a less
             frequently used path so proabably not worth it.  */
          dest -= stride[n] * extent[n];
          n++;
          if (n == dim)
            {
              dest = NULL;
              break;
            }
          else
            {
              count[n]++;
              dest += stride[n];
            }
        }
    }
}

