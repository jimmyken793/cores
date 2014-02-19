/* Teensyduino Core Library
 * http://www.pjrc.com/teensy/
 * Copyright (c) 2013 PJRC.COM, LLC.
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * 1. The above copyright notice and this permission notice shall be 
 * included in all copies or substantial portions of the Software.
 *
 * 2. If the Software is incorporated into a build system that allows 
 * selection among a list of target devices, then similar target
 * devices manufactured by PJRC.COM must be included in the list of
 * target devices and selectable in the same manner.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#ifndef USBrawhid_h_
#define USBrawhid_h_

#if defined(USB_DENNAO)

#include <inttypes.h>
#include <usb_desc.h>

// C language implementation
#ifdef __cplusplus
extern "C" {
#endif
int usb_dennao_recv(void *buffer, const uint16_t len, uint16_t timeout);
int usb_dennao_available(void);
int usb_dennao_send(const void *buffer, const uint16_t len, uint16_t timeout);
#ifdef __cplusplus
}
#endif


// C++ interface
#ifdef __cplusplus
class usb_dennao_class
{
public:
	int available(void) {return usb_dennao_available(); }
	int recv(void *buffer, const uint16_t len, uint16_t timeout) { return usb_dennao_recv(buffer, len, timeout); }
	int recv(void *buffer, uint16_t timeout) { return usb_dennao_recv(buffer, DENNAO_RX_SIZE, timeout); }
	int send(const void *buffer, const uint16_t len, uint16_t timeout) { return usb_dennao_send(buffer, len, timeout); }
	int send(const void *buffer, uint16_t timeout) { return usb_dennao_send(buffer, DENNAO_TX_SIZE, timeout); }
};

extern usb_dennao_class Dennao;

#endif // __cplusplus

#endif // USB_DENNAO

#endif // USBrawhid_h_
