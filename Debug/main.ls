   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.11.14 - 18 Nov 2019
   3                     ; Generator (Limited) V4.4.11 - 19 Nov 2019
  55                     ; 10 void assert_failed(u8* file, u32 line)
  55                     ; 11 { 
  57                     	switch	.text
  58  0000               _assert_failed:
  62  0000               L72:
  63  0000 20fe          	jra	L72
  76                     	bsct
  77  0000               _time:
  78  0000 0000          	dc.w	0
  79  0002               _time2:
  80  0002 0000          	dc.w	0
 122                     ; 19 void main(void){
 123                     	switch	.text
 124  0002               _main:
 128                     ; 20 	CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1); // taktovat MCU na 16MHz
 130  0002 4f            	clr	a
 131  0003 cd0000        	call	_CLK_HSIPrescalerConfig
 133                     ; 21 	init_milis(); // rozbìhnout milis èasovaè
 135  0006 cd0000        	call	_init_milis
 137                     ; 23 	GPIO_Init(LED_PORT, LED_PIN, GPIO_MODE_OUT_PP_LOW_SLOW);
 139  0009 4bc0          	push	#192
 140  000b 4b08          	push	#8
 141  000d ae5005        	ldw	x,#20485
 142  0010 cd0000        	call	_GPIO_Init
 144  0013 85            	popw	x
 145                     ; 25 	UART1_DeInit();
 147  0014 cd0000        	call	_UART1_DeInit
 149                     ; 35   UART1_Init((uint32_t)115200,
 149                     ; 36             	UART1_WORDLENGTH_8D,
 149                     ; 37 							UART1_STOPBITS_1,
 149                     ; 38 							UART1_PARITY_NO,
 149                     ; 39               UART1_SYNCMODE_CLOCK_DISABLE,
 149                     ; 40 							UART1_MODE_TXRX_ENABLE
 149                     ; 41 						);
 151  0017 4b0c          	push	#12
 152  0019 4b80          	push	#128
 153  001b 4b00          	push	#0
 154  001d 4b00          	push	#0
 155  001f 4b00          	push	#0
 156  0021 aec200        	ldw	x,#49664
 157  0024 89            	pushw	x
 158  0025 ae0001        	ldw	x,#1
 159  0028 89            	pushw	x
 160  0029 cd0000        	call	_UART1_Init
 162  002c 5b09          	addw	sp,#9
 163                     ; 42 	UART1_Cmd(DISABLE);
 165  002e 4f            	clr	a
 166  002f cd0000        	call	_UART1_Cmd
 168                     ; 43 	UART1_Cmd(ENABLE);
 170  0032 a601          	ld	a,#1
 171  0034 cd0000        	call	_UART1_Cmd
 173                     ; 45 	UART1_ITConfig(UART1_IT_RXNE_OR, ENABLE); // povolí pøerušení UART1 Rx
 175  0037 4b01          	push	#1
 176  0039 ae0205        	ldw	x,#517
 177  003c cd0000        	call	_UART1_ITConfig
 179  003f 84            	pop	a
 180                     ; 46   enableInterrupts();                       // globálnì povolí pøerušení
 183  0040 9a            rim
 185  0041               L15:
 186                     ; 63 		if (milis() - time > 333) {
 188  0041 cd0000        	call	_milis
 190  0044 72b00000      	subw	x,_time
 191  0048 a3014e        	cpw	x,#334
 192  004b 250e          	jrult	L55
 193                     ; 64 			time = milis();
 195  004d cd0000        	call	_milis
 197  0050 bf00          	ldw	_time,x
 198                     ; 65 			LED_FLIP;
 200  0052 4b08          	push	#8
 201  0054 ae5005        	ldw	x,#20485
 202  0057 cd0000        	call	_GPIO_WriteReverse
 204  005a 84            	pop	a
 205  005b               L55:
 206                     ; 67 		if (milis() - time2 > 2000) {
 208  005b cd0000        	call	_milis
 210  005e 72b00002      	subw	x,_time2
 211  0062 a307d1        	cpw	x,#2001
 212  0065 25da          	jrult	L15
 213                     ; 68 			time2 = milis();
 215  0067 cd0000        	call	_milis
 217  006a bf02          	ldw	_time2,x
 218                     ; 69 			printf("QQQ");
 220  006c ae0000        	ldw	x,#L16
 221  006f cd0000        	call	_printf
 223  0072 20cd          	jra	L15
 259                     ; 74 char putchar (char c)
 259                     ; 75 {
 260                     	switch	.text
 261  0074               _putchar:
 263  0074 88            	push	a
 264       00000000      OFST:	set	0
 267  0075               L301:
 268                     ; 77   while (UART1_GetFlagStatus(UART1_FLAG_TXE) == RESET); 
 270  0075 ae0080        	ldw	x,#128
 271  0078 cd0000        	call	_UART1_GetFlagStatus
 273  007b 4d            	tnz	a
 274  007c 27f7          	jreq	L301
 275                     ; 79   UART1_SendData8(c);
 277  007e 7b01          	ld	a,(OFST+1,sp)
 278  0080 cd0000        	call	_UART1_SendData8
 280                     ; 81   return (c);
 282  0083 7b01          	ld	a,(OFST+1,sp)
 285  0085 5b01          	addw	sp,#1
 286  0087 81            	ret
 322                     ; 85 char getchar(void)
 322                     ; 86 /* Funkce pøjímá textová data s UART */
 322                     ; 87 {
 323                     	switch	.text
 324  0088               _getchar:
 326  0088 89            	pushw	x
 327       00000002      OFST:	set	2
 330                     ; 89   int c = 0;
 333  0089               L721:
 334                     ; 92   while (UART1_GetFlagStatus(UART1_FLAG_RXNE) == RESET) { 
 336  0089 ae0020        	ldw	x,#32
 337  008c cd0000        	call	_UART1_GetFlagStatus
 339  008f 4d            	tnz	a
 340  0090 27f7          	jreq	L721
 341                     ; 95 	c = UART1_ReceiveData8();
 343  0092 cd0000        	call	_UART1_ReceiveData8
 345  0095 5f            	clrw	x
 346  0096 97            	ld	xl,a
 347  0097 1f01          	ldw	(OFST-1,sp),x
 349                     ; 96   return (c);
 351  0099 7b02          	ld	a,(OFST+0,sp)
 354  009b 85            	popw	x
 355  009c 81            	ret
 392                     ; 99 INTERRUPT_HANDLER(UART1_RX_IRQHandler, 18)
 392                     ; 100 {
 394                     	switch	.text
 395  009d               f_UART1_RX_IRQHandler:
 397  009d 8a            	push	cc
 398  009e 84            	pop	a
 399  009f a4bf          	and	a,#191
 400  00a1 88            	push	a
 401  00a2 86            	pop	cc
 402       00000001      OFST:	set	1
 403  00a3 3b0002        	push	c_x+2
 404  00a6 be00          	ldw	x,c_x
 405  00a8 89            	pushw	x
 406  00a9 3b0002        	push	c_y+2
 407  00ac be00          	ldw	x,c_y
 408  00ae 89            	pushw	x
 409  00af 88            	push	a
 412                     ; 101 	char c = UART1_ReceiveData8();  // Vlajka shozena automaticky
 414  00b0 cd0000        	call	_UART1_ReceiveData8
 416  00b3 6b01          	ld	(OFST+0,sp),a
 418                     ; 102 	UART1_SendData8(c);
 420  00b5 7b01          	ld	a,(OFST+0,sp)
 421  00b7 cd0000        	call	_UART1_SendData8
 423                     ; 105 	return;
 426  00ba 84            	pop	a
 427  00bb 85            	popw	x
 428  00bc bf00          	ldw	c_y,x
 429  00be 320002        	pop	c_y+2
 430  00c1 85            	popw	x
 431  00c2 bf00          	ldw	c_x,x
 432  00c4 320002        	pop	c_x+2
 433  00c7 80            	iret
 474                     	xdef	f_UART1_RX_IRQHandler
 475                     	xdef	_main
 476                     	xdef	_time2
 477                     	xdef	_time
 478                     	switch	.ubsct
 479  0000               _znak:
 480  0000 00            	ds.b	1
 481                     	xdef	_znak
 482                     	xdef	_putchar
 483                     	xref	_printf
 484                     	xdef	_getchar
 485                     	xref	_init_milis
 486                     	xref	_milis
 487                     	xdef	_assert_failed
 488                     	xref	_UART1_GetFlagStatus
 489                     	xref	_UART1_SendData8
 490                     	xref	_UART1_ReceiveData8
 491                     	xref	_UART1_ITConfig
 492                     	xref	_UART1_Cmd
 493                     	xref	_UART1_Init
 494                     	xref	_UART1_DeInit
 495                     	xref	_GPIO_WriteReverse
 496                     	xref	_GPIO_Init
 497                     	xref	_CLK_HSIPrescalerConfig
 498                     .const:	section	.text
 499  0000               L16:
 500  0000 51515100      	dc.b	"QQQ",0
 501                     	xref.b	c_x
 502                     	xref.b	c_y
 522                     	end
