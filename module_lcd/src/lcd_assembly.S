.text
.cc_top lcd_fast_write
.align 4
.globl lcd_fast_write
.type  lcd_fast_write, @function
lcd_fast_write:

 	//r0 buffer pointer
	//r1 time
	//r2 resource id of dq
	//r3 resource id of de

    setpt res[r2], r1
	setpt res[r3], r1

	ldaw r11, cp[0]
	set cp, r0
	ldw r0, cp[0]

	ldc r1, 1
	out res[r2], r0

	shr r0, r0, 16
	out res[r3], r1
	ldc r1, 0
	out res[r2], r0

	#include "lcd_generated.inc"
	out res[r3], r1

	set cp, r11
	retsp 0

.globl lcd_fast_write.nstackwords
.linkset lcd_fast_write.nstackwords, 0
.globl lcd_fast_write.maxtimers
.linkset lcd_fast_write.maxtimers, 0
.globl lcd_fast_write.maxchanends
.linkset lcd_fast_write.maxchanends, 0
.globl lcd_fast_write.maxthreads
.linkset lcd_fast_write.maxthreads, 1

.cc_bottom lcd_fast_write
