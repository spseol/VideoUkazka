// Vzorový projekt 

#include "stm8s.h"
#include "assert.h"
#include "milis.h"
#include <stdio.h>

//#include "spse_stm8.h"
//#include "stm8_hd44780.h"

#define LED_PORT GPIOB
#define LED_PIN  GPIO_PIN_3
#define LED_ON GPIO_WriteHigh(LED_PORT, LED_PIN)
#define LED_OFF  GPIO_WriteLow(LED_PORT, LED_PIN)
#define LED_FLIP GPIO_WriteReverse(LED_PORT, LED_PIN)

char znak;
uint16_t time = 0;
uint16_t time2 = 0;
void main(void){
	CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1); // taktovat MCU na 16MHz
	init_milis(); // rozbìhnout milis èasovaè
	
	GPIO_Init(LED_PORT, LED_PIN, GPIO_MODE_OUT_PP_LOW_SLOW);
	
	UART1_DeInit();
  /* UART1 configuration ------------------------------------------------------*/
  /* UART1 configured as follow:
        - BaudRate = 115200 baud  
        - Word Length = 8 Bits
        - One Stop Bit
        - No parity
        - Receive and transmit enabled
        - UART1 Clock disabled
  */
  UART1_Init((uint32_t)115200,
            	UART1_WORDLENGTH_8D,
							UART1_STOPBITS_1,
							UART1_PARITY_NO,
              UART1_SYNCMODE_CLOCK_DISABLE,
							UART1_MODE_TXRX_ENABLE
						);
	UART1_Cmd(DISABLE);
	UART1_Cmd(ENABLE);
	
	UART1_ITConfig(UART1_IT_RXNE_OR, ENABLE); // povolí pøerušení UART1 Rx
  enableInterrupts();                       // globálnì povolí pøerušení
	
	
	
  
	while (1){
		/*znak = getchar();
		putchar(znak);
		if (znak == 'a' || znak == 'A') {
			// rožnu LED
			LED_ON;
		}
		if (znak == 'b' || znak == 'B') {
			// zhasnu LED
			LED_OFF;
		}*/
		
		if (milis() - time > 333) {
			time = milis();
			LED_FLIP;
		}
		if (milis() - time2 > 2000) {
			time2 = milis();
			printf("QQQ");
		}
  }
}

char putchar (char c)
{
  /* Loop until the end of transmission */
  while (UART1_GetFlagStatus(UART1_FLAG_TXE) == RESET); 
  /* Write a character to the UART1 */
  UART1_SendData8(c);
 
  return (c);
}


char getchar(void)
/* Funkce pøjímá textová data s UART */
{

  int c = 0;
  
	/* Loop until the Read data register flag is SET */
  while (UART1_GetFlagStatus(UART1_FLAG_RXNE) == RESET) { 
		;
	}
	c = UART1_ReceiveData8();
  return (c);
}

INTERRUPT_HANDLER(UART1_RX_IRQHandler, 18)
{
	char c = UART1_ReceiveData8();  // Vlajka shozena automaticky
	UART1_SendData8(c);
	//UART1_ClearFlag(UART1_FLAG_RXNE);  // Vlajka shozena ruènì
	//LED_FLIP;
	return;
}

