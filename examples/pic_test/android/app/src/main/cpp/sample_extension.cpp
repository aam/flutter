// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "include/dart_api.h"
#include "include/dart_native_api.h"


Dart_NativeFunction ResolveName(Dart_Handle name,
                                int argc,
                                bool* auto_setup_scope);


DART_EXPORT Dart_Handle sample_extension_Init(Dart_Handle parent_library) {
  if (Dart_IsError(parent_library)) {
    return parent_library;
  }

  Dart_Handle result_code =
      Dart_SetNativeResolver(parent_library, ResolveName, NULL);
  if (Dart_IsError(result_code)) {
    return result_code;
  }

  return Dart_Null();
}

Dart_Handle HandleError(Dart_Handle handle) {
  if (Dart_IsError(handle)) {
    Dart_PropagateError(handle);
  }
  return handle;
}

uint8_t* randomArray(int seed, int length) {
  if (length <= 0 || length > 1000*1000*1024) {
    return NULL;
  }
  uint8_t* values = reinterpret_cast<uint8_t*>(malloc(length));
  if (NULL == values) {
    return NULL;
  }
  srand(seed);
  for (int i = 0; i < length; ++i) {
    values[i] = rand() % 256;
  }
  return values;
}

static void ContentsFinalizer(void* isolate_callback_data,
                              Dart_WeakPersistentHandle handle,
                              void* peer) {
  printf("ContentsFinalizer asked to clean up %p\n", peer);
  uint8_t* data = reinterpret_cast<uint8_t*>(peer);
//  free(data);
}

void AllocateExternalUint8List(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  int seed = 0;
  int length = 1024*1024*512;
  uint8_t* values = randomArray(seed, length);
  printf("AllocateExternalUint8List allocated %p\n", values);
  Dart_Handle external_typed_data = Dart_NewExternalTypedDataWithFinalizer(
        Dart_TypedData_kUint8, values, length, values,
          length, ContentsFinalizer);

  Dart_Handle handle_result = HandleError(external_typed_data);
  Dart_SetReturnValue(arguments, handle_result);
  Dart_ExitScope();
}

void TransferrableWrapper_Create(Dart_NativeArguments arguments) {
  Dart_EnterScope();

  Dart_Handle data_obj = Dart_GetNativeArgument(arguments, 0);

  Dart_Handle size_object = HandleError(Dart_GetNativeArgument(arguments, 1));
  int64_t size;
  HandleError(Dart_IntegerToInt64(size_object, &size));

  uint8_t* data = reinterpret_cast<uint8_t*>(malloc(size));
  data[0] = 42;
  data[1] = 43;
  HandleError(Dart_SetNativeInstanceField(
      data_obj,
      0,
      reinterpret_cast<intptr_t>(data)));

  Dart_NewWeakPersistentHandle(
      data_obj,
      data,
      0,
      ContentsFinalizer);

  Dart_Handle external_typed_data = Dart_NewExternalTypedDataWithFinalizer(
        Dart_TypedData_kUint8, data, size, data,
          size, ContentsFinalizer);

  Dart_Handle handle_result = HandleError(external_typed_data);
  Dart_SetReturnValue(arguments, handle_result);

  Dart_ExitScope();
}

void TransferrableWrapper_Release(Dart_NativeArguments arguments) {
  Dart_EnterScope();

  Dart_Handle data_obj = HandleError(Dart_GetNativeArgument(arguments, 0));
  uint8_t* data;
  HandleError(Dart_GetNativeInstanceField(
      data_obj,
      0,
      reinterpret_cast<intptr_t*>(&data)));

  free(data);
}

struct FunctionLookup {
  const char* name;
  Dart_NativeFunction function;
};

FunctionLookup function_list[] = {
    {"AllocateExternalUint8List", AllocateExternalUint8List},
    {"TransferrableWrapper_Create", TransferrableWrapper_Create},
    {"TransferrableWrapper_Release", TransferrableWrapper_Release},
    {NULL, NULL}};

Dart_NativeFunction ResolveName(Dart_Handle name,
                                int argc,
                                bool* auto_setup_scope) {
  if (!Dart_IsString(name)) {
    return NULL;
  }
  Dart_NativeFunction result = NULL;
  if (auto_setup_scope == NULL) {
    return NULL;
  }

  Dart_EnterScope();
  const char* cname;
  HandleError(Dart_StringToCString(name, &cname));

  for (int i=0; function_list[i].name != NULL; ++i) {
    if (strcmp(function_list[i].name, cname) == 0) {
      *auto_setup_scope = true;
      result = function_list[i].function;
      break;
    }
  }

  Dart_ExitScope();
  return result;
}
