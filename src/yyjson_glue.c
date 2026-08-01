/* SPDX-License-Identifier: MIT */
#include "yyjson.h"
#include <string.h>

yyjson_doc *fy_yyjson_read(const char *dat, size_t len, yyjson_read_flag flg) {
    return yyjson_read(dat, len, flg);
}

yyjson_doc *fy_yyjson_read_opts(char *dat, size_t len, yyjson_read_flag flg,
                                 const yyjson_alc *alc, yyjson_read_err *err) {
    return yyjson_read_opts(dat, len, flg, alc, err);
}

void fy_yyjson_doc_free(yyjson_doc *doc) {
    yyjson_doc_free(doc);
}

yyjson_val *fy_yyjson_doc_get_root(yyjson_doc *doc) {
    return yyjson_doc_get_root(doc);
}

char *fy_yyjson_write(const yyjson_doc *doc, yyjson_write_flag flg, size_t *len) {
    return yyjson_write(doc, flg, len);
}

char *fy_yyjson_write_opts(const yyjson_doc *doc, yyjson_write_flag flg,
                            const yyjson_alc *alc, size_t *len,
                            yyjson_write_err *err) {
    return yyjson_write_opts(doc, flg, alc, len, err);
}

void fy_free(void *ptr) {
    free(ptr);
}

yyjson_type fy_yyjson_get_type(yyjson_val *val) {
    return yyjson_get_type(val);
}

yyjson_subtype fy_yyjson_get_subtype(yyjson_val *val) {
    return yyjson_get_subtype(val);
}

const char *fy_yyjson_get_type_desc(yyjson_val *val) {
    return yyjson_get_type_desc(val);
}

bool fy_yyjson_is_null(yyjson_val *val) { return yyjson_is_null(val); }
bool fy_yyjson_is_true(yyjson_val *val) { return yyjson_is_true(val); }
bool fy_yyjson_is_false(yyjson_val *val) { return yyjson_is_false(val); }
bool fy_yyjson_is_bool(yyjson_val *val) { return yyjson_is_bool(val); }
bool fy_yyjson_is_num(yyjson_val *val) { return yyjson_is_num(val); }
bool fy_yyjson_is_int(yyjson_val *val) { return yyjson_is_int(val); }
bool fy_yyjson_is_uint(yyjson_val *val) { return yyjson_is_uint(val); }
bool fy_yyjson_is_sint(yyjson_val *val) { return yyjson_is_sint(val); }
bool fy_yyjson_is_real(yyjson_val *val) { return yyjson_is_real(val); }
bool fy_yyjson_is_str(yyjson_val *val) { return yyjson_is_str(val); }
bool fy_yyjson_is_arr(yyjson_val *val) { return yyjson_is_arr(val); }
bool fy_yyjson_is_obj(yyjson_val *val) { return yyjson_is_obj(val); }
bool fy_yyjson_is_ctn(yyjson_val *val) { return yyjson_is_ctn(val); }

bool fy_yyjson_get_bool(yyjson_val *val) { return yyjson_get_bool(val); }
int64_t fy_yyjson_get_sint(yyjson_val *val) { return yyjson_get_sint(val); }
uint64_t fy_yyjson_get_uint(yyjson_val *val) { return yyjson_get_uint(val); }
double fy_yyjson_get_real(yyjson_val *val) { return yyjson_get_real(val); }
double fy_yyjson_get_num(yyjson_val *val) { return yyjson_get_num(val); }
const char *fy_yyjson_get_str(yyjson_val *val) { return yyjson_get_str(val); }
size_t fy_yyjson_get_len(yyjson_val *val) { return yyjson_get_len(val); }

size_t fy_yyjson_arr_size(yyjson_val *arr) { return yyjson_arr_size(arr); }
yyjson_val *fy_yyjson_arr_get(yyjson_val *arr, size_t idx) { return yyjson_arr_get(arr, idx); }
yyjson_val *fy_yyjson_arr_get_first(yyjson_val *arr) { return yyjson_arr_get_first(arr); }
yyjson_val *fy_yyjson_arr_get_last(yyjson_val *arr) { return yyjson_arr_get_last(arr); }

bool fy_yyjson_arr_iter_with(yyjson_val *arr, yyjson_arr_iter *iter) {
    return yyjson_arr_iter_init(arr, iter);
}

yyjson_val *fy_yyjson_arr_iter_next(yyjson_arr_iter *iter) {
    return yyjson_arr_iter_next(iter);
}

size_t fy_yyjson_obj_size(yyjson_val *obj) { return yyjson_obj_size(obj); }

yyjson_val *fy_yyjson_obj_get(yyjson_val *obj, const char *key) {
    return yyjson_obj_get(obj, key);
}

yyjson_val *fy_yyjson_obj_getn(yyjson_val *obj, const char *key, size_t key_len) {
    return yyjson_obj_getn(obj, key, key_len);
}

bool fy_yyjson_obj_iter_with(yyjson_val *obj, yyjson_obj_iter *iter) {
    return yyjson_obj_iter_init(obj, iter);
}

yyjson_val *fy_yyjson_obj_iter_next(yyjson_obj_iter *iter) {
    return yyjson_obj_iter_next(iter);
}

yyjson_val *fy_yyjson_obj_iter_get_val(yyjson_val *key) {
    return yyjson_obj_iter_get_val(key);
}

yyjson_mut_doc *fy_yyjson_mut_doc_new(yyjson_alc *alc) {
    return yyjson_mut_doc_new(alc);
}

void fy_yyjson_mut_doc_free(yyjson_mut_doc *doc) {
    yyjson_mut_doc_free(doc);
}

void fy_yyjson_mut_doc_set_root(yyjson_mut_doc *doc, yyjson_mut_val *val) {
    yyjson_mut_doc_set_root(doc, val);
}

yyjson_mut_val *fy_yyjson_mut_doc_get_root(yyjson_mut_doc *doc) {
    return yyjson_mut_doc_get_root(doc);
}

char *fy_yyjson_mut_write(const yyjson_mut_doc *doc, yyjson_write_flag flg, size_t *len) {
    return yyjson_mut_write(doc, flg, len);
}

char *fy_yyjson_mut_write_opts(const yyjson_mut_doc *doc, yyjson_write_flag flg,
                                const yyjson_alc *alc, size_t *len,
                                yyjson_write_err *err) {
    return yyjson_mut_write_opts(doc, flg, alc, len, err);
}

yyjson_mut_val *fy_yyjson_mut_null(yyjson_mut_doc *doc) { return yyjson_mut_null(doc); }
yyjson_mut_val *fy_yyjson_mut_true(yyjson_mut_doc *doc) { return yyjson_mut_true(doc); }
yyjson_mut_val *fy_yyjson_mut_false(yyjson_mut_doc *doc) { return yyjson_mut_false(doc); }
yyjson_mut_val *fy_yyjson_mut_bool(yyjson_mut_doc *doc, bool v) { return yyjson_mut_bool(doc, v); }
yyjson_mut_val *fy_yyjson_mut_sint(yyjson_mut_doc *doc, int64_t v) { return yyjson_mut_sint(doc, v); }
yyjson_mut_val *fy_yyjson_mut_uint(yyjson_mut_doc *doc, uint64_t v) { return yyjson_mut_uint(doc, v); }
yyjson_mut_val *fy_yyjson_mut_real(yyjson_mut_doc *doc, double v) { return yyjson_mut_real(doc, v); }

yyjson_mut_val *fy_yyjson_mut_str(yyjson_mut_doc *doc, const char *str) {
    return yyjson_mut_str(doc, str);
}

yyjson_mut_val *fy_yyjson_mut_strn(yyjson_mut_doc *doc, const char *str, size_t len) {
    return yyjson_mut_strn(doc, str, len);
}

yyjson_mut_val *fy_yyjson_mut_strcpy(yyjson_mut_doc *doc, const char *str) {
    return yyjson_mut_strcpy(doc, str);
}

yyjson_mut_val *fy_yyjson_mut_strncpy(yyjson_mut_doc *doc, const char *str, size_t len) {
    return yyjson_mut_strncpy(doc, str, len);
}

yyjson_mut_val *fy_yyjson_mut_arr(yyjson_mut_doc *doc) { return yyjson_mut_arr(doc); }

bool fy_yyjson_mut_arr_add_val(yyjson_mut_val *arr, yyjson_mut_val *val) {
    return yyjson_mut_arr_add_val(arr, val);
}

bool fy_yyjson_mut_arr_add_null(yyjson_mut_doc *doc, yyjson_mut_val *arr) {
    return yyjson_mut_arr_add_null(doc, arr);
}

bool fy_yyjson_mut_arr_add_bool(yyjson_mut_doc *doc, yyjson_mut_val *arr, bool v) {
    return yyjson_mut_arr_add_bool(doc, arr, v);
}

bool fy_yyjson_mut_arr_add_sint(yyjson_mut_doc *doc, yyjson_mut_val *arr, int64_t v) {
    return yyjson_mut_arr_add_sint(doc, arr, v);
}

bool fy_yyjson_mut_arr_add_uint(yyjson_mut_doc *doc, yyjson_mut_val *arr, uint64_t v) {
    return yyjson_mut_arr_add_uint(doc, arr, v);
}

bool fy_yyjson_mut_arr_add_real(yyjson_mut_doc *doc, yyjson_mut_val *arr, double v) {
    return yyjson_mut_arr_add_real(doc, arr, v);
}

bool fy_yyjson_mut_arr_add_str(yyjson_mut_doc *doc, yyjson_mut_val *arr, const char *str) {
    return yyjson_mut_arr_add_str(doc, arr, str);
}

bool fy_yyjson_mut_arr_add_strn(yyjson_mut_doc *doc, yyjson_mut_val *arr,
                                 const char *str, size_t len) {
    return yyjson_mut_arr_add_strncpy(doc, arr, str, len);
}

yyjson_mut_val *fy_yyjson_mut_obj(yyjson_mut_doc *doc) { return yyjson_mut_obj(doc); }

bool fy_yyjson_mut_obj_add(yyjson_mut_val *obj, yyjson_mut_val *key, yyjson_mut_val *val) {
    return yyjson_mut_obj_add(obj, key, val);
}

bool fy_yyjson_mut_obj_add_val(yyjson_mut_doc *doc, yyjson_mut_val *obj,
                                const char *key, yyjson_mut_val *val) {
    yyjson_mut_val *key_val = yyjson_mut_strcpy(doc, key);
    if (!key_val) return false;
    return yyjson_mut_obj_add(obj, key_val, val);
}

bool fy_yyjson_mut_obj_add_null(yyjson_mut_doc *doc, yyjson_mut_val *obj, const char *key) {
    yyjson_mut_val *key_val = yyjson_mut_strcpy(doc, key);
    yyjson_mut_val *val = yyjson_mut_null(doc);
    if (!key_val) return false;
    return yyjson_mut_obj_add(obj, key_val, val);
}

bool fy_yyjson_mut_obj_add_bool(yyjson_mut_doc *doc, yyjson_mut_val *obj,
                                 const char *key, bool v) {
    yyjson_mut_val *key_val = yyjson_mut_strcpy(doc, key);
    yyjson_mut_val *val = yyjson_mut_bool(doc, v);
    if (!key_val || !val) return false;
    return yyjson_mut_obj_add(obj, key_val, val);
}

bool fy_yyjson_mut_obj_add_sint(yyjson_mut_doc *doc, yyjson_mut_val *obj,
                                 const char *key, int64_t v) {
    yyjson_mut_val *key_val = yyjson_mut_strcpy(doc, key);
    yyjson_mut_val *val = yyjson_mut_sint(doc, v);
    if (!key_val || !val) return false;
    return yyjson_mut_obj_add(obj, key_val, val);
}

bool fy_yyjson_mut_obj_add_uint(yyjson_mut_doc *doc, yyjson_mut_val *obj,
                                 const char *key, uint64_t v) {
    yyjson_mut_val *key_val = yyjson_mut_strcpy(doc, key);
    yyjson_mut_val *val = yyjson_mut_uint(doc, v);
    if (!key_val || !val) return false;
    return yyjson_mut_obj_add(obj, key_val, val);
}

bool fy_yyjson_mut_obj_add_real(yyjson_mut_doc *doc, yyjson_mut_val *obj,
                                 const char *key, double v) {
    yyjson_mut_val *key_val = yyjson_mut_strcpy(doc, key);
    yyjson_mut_val *val = yyjson_mut_real(doc, v);
    if (!key_val || !val) return false;
    return yyjson_mut_obj_add(obj, key_val, val);
}

bool fy_yyjson_mut_obj_add_str(yyjson_mut_doc *doc, yyjson_mut_val *obj,
                                const char *key, const char *str) {
    yyjson_mut_val *key_val = yyjson_mut_strcpy(doc, key);
    yyjson_mut_val *val = yyjson_mut_strcpy(doc, str);
    if (!key_val || !val) return false;
    return yyjson_mut_obj_add(obj, key_val, val);
}

bool fy_yyjson_mut_obj_add_strn(yyjson_mut_doc *doc, yyjson_mut_val *obj,
                                 const char *key, const char *str, size_t len) {
    yyjson_mut_val *key_val = yyjson_mut_strcpy(doc, key);
    yyjson_mut_val *val = yyjson_mut_strncpy(doc, str, len);
    if (!key_val || !val) return false;
    return yyjson_mut_obj_add(obj, key_val, val);
}

yyjson_mut_val *fy_yyjson_val_mut_copy(yyjson_mut_doc *doc, yyjson_val *val) {
    return yyjson_val_mut_copy(doc, val);
}

yyjson_mut_val *fy_yyjson_mut_val_mut_copy(yyjson_mut_doc *doc, yyjson_mut_val *val) {
    return yyjson_mut_val_mut_copy(doc, val);
}
