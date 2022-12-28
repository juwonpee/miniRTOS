#include "stdint.h"
#include "uart.h"

#include "stdio.h"


void main(void)
{
    Hal_uart_init();
    debug_printf("Hello miniRTOS");
}