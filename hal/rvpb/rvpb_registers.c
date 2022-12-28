/*
 * Regs.c
 *
 *      Author: juwonpee
 */

#ifndef HAL_RVPB_INTERRUPT_H
#define HAL_RVPB_INTERRUPT_H


#include "stdint.h"

#include "rvpb_uart.h"

volatile PL011_t* Uart = (*PL011_t)UART_BASE_ADDRESS0;


#endif // HAL_RVPB_INTERRUPT_H
