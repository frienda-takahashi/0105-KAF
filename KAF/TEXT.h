//  TEXT subset Created by SHINYA TAKAHASHI on 2024/01/02.

#pragma once
#include "MM.h"



#define TEXTTYPE_LABEL              'lbl'
#define TEXTTYPE_FIELD              'fld'
#define TEXTTYPE_TEXTVIEW_EDITABLE  'txe'



void *TEXTNew(i32 type, void *parent, f64_4 frame);
void  TEXTSetText(void *textView, char *text);
void  TEXTSetBackgroundColor(void *textView, f64_4 color);


