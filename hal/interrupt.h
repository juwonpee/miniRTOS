#pragma once

#define INTERRUPT_HANDLER_NUM 255

#include "stdint.h"
typedef void (*interruptHandler_fptr)(void);

void interrupt_init(void);
void interrupt_enable(uint32_t interrupt_num);
void interrupt_disable(uint32_t intterrupt_num);
void interrupt_register(interruptHandler_fptr handler, uint32_t interrupt_num);
void interrupt_run_handler(void);