.text
.cc_top lcd_fast_write
.align 4
.globl lcd_fast_write
.type  lcd_fast_write, @function
lcd_fast_write:
/*
 	//r0 unsigned &time
	//r1 unsigned * unsafe buffer
	//r2 lcd_ports &p

	//load rgb and de from p

    setpt res[rgb], time
	setpt res[de], 	time

	ldc c, 1
	out c, res[de]

	ldw c, buffer[0]
	out c, res[rgb]

	//load c with the width
	add time, time, c

	ldc c, 4

	ldaw buffer, buffer[n]
	ldaw c, c[-n]

	setpt res[de], time	//blocking instruction
	out c, res[de]		//c has the bottom bit as 0

loop:
	ldw t, buffer[c]
	out t, res[rgb]
	add c, c, 4
	bt c, loop
*/
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
.cc_top lcd_fast_loop
.align 4
.globl lcd_fast_loop
.type  lcd_fast_loop, @function

#define rgb r0
#define buffer r1
#define i r2
#define t r11

lcd_fast_loop:
	ldw t, buffer[i]
	out res[rgb], t
	add i, i, 1
	bt i, lcd_fast_loop
no:
	retsp 0

.globl lcd_fast_loop.nstackwords
.linkset lcd_fast_loop.nstackwords, 0
.globl lcd_fast_loop.maxtimers
.linkset lcd_fast_loop.maxtimers, 0
.globl lcd_fast_loop.maxchanends
.linkset lcd_fast_loop.maxchanends, 0
.globl lcd_fast_loop.maxthreads
.linkset lcd_fast_loop.maxthreads, 1

.cc_bottom lcd_fast_loop
