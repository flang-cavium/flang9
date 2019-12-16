/*
 * Copyright (c) 2017, NVIDIA CORPORATION.  All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


/* FIXME: describe what these messages are for.  This is Japanese in
 * UTF-8 encoding.  The original encoding was EUC-JP.  Some Japanese
 * speaker should check these strings for correctness.
 */
static char *kanjitxt[] = {
    /* 200 */ "ｘｘｘ",
    /* 201 */ "入出力指定子の値が不当です",
    /* 202 */ "入出力指定子に矛盾があります",
    /* 203 */ "レコード長が指定されていません",
    /* 204 */ "読み込み権だけのファイルの使用が不当です",
    /* 205 */ "'SCRATCH'と'SAVE'／'KEEP'の両方が指定されています",
    /* 206 */ "名前付きファイルを'SCRATCH'として開こうとしています",
    /* 207 */ "ファイルは既に他の装置と接続しています",
    /* 208 */ "既存のファイルに対して'NEW'を指定しています",
    /* 209 */ "存在していないファイルに対して'OLD'を指定しています",
    /* 210 */ "動的メモリ割付けに失敗しました",
    /* 211 */ "ファイル名が不当です",
    /* 212 */ "装置番号が不当です",
    /* 213 */ "ｙｙｙ",
    /* 214 */ "ｚｚｚ",
    /* 215 */ "書式付き／書式なしファイルが矛盾しています",
    /* 216 */ "ｗｗｗ",
    /* 217 */ "ファイルの終わりを越えて入力しようとしています",
    /* 218 */ "attempt to read (nonadvancing) past end of record",
    /* 219 */ "レコードの終わりを越えて入出力しようとしています",
    /* 220 */ "最後の内部レコードの後に書き込みました",
    /* 221 */ "書式文字列中の構文誤りがあります",
    /* 222 */ "書式文字列中の括弧の対応がとれていません",
    /* 223 */ "Ｐ編集記述子またはＴ編集記述子が不当です：値の指定がありません",
    /* 224 */ "書式中のＨ形編集記述子またはアポストロフィ編集記述子が不当です",
    /* 225 */ "字句誤り：認識できない字句です",
    /* 226 */ "書式中に認識できない編集記述子があります",
    /* 227 */ "ｃｃｃ",
    /* 228 */ "群の発見前にファイルの終わりを検出しました",
    /* 229 */ "群の処理中にファイルの終わりを検出しました",
    /* 230 */ "けた移動数が範囲［−１２８，１２７］外です",
    /* 231 */ "データ変換誤り",
    /* 232 */ "ｆｆｆ",
    /* 233 */ "群項目の初期値が多すぎます",
    /* 234 */ "不当な編集記述子です",
    /* 235 */ "編集記述子とデータの型が合っていません",
    /* 236 */ "書式付きレコードが２０００文字より長くなっています",
    /* 237 */ "拡張精度型はサポートしていません",
    /* 238 */ "タブの値が範囲外です",
    /* 239 */ "英字名が群のメンバーではありません",
    /* 240 */ "ａａａ",
    /* 241 */ "ｄｄｄ",
    /* 242 */ "直接探査ファイルに対しては不当な操作です",
    /* 243 */ "書式仕様中の括弧の入れ子が深すぎます",
    /* 244 */ "構文誤り：　英字名の指定がありません",
    /* 245 */ "群定義に構文誤りがあります",
    /* 246 */ "編集記述子に対する際限ない書式の走査があります",
    /* 247 */ "ｇｇｇ",
    /* 248 */ "添字または部分列の指定が不当です",
    /* 249 */ "書式仕様の誤り：　Ｅ形、Ｆ形、Ｇ形またはＤ形編集記述子が不当で",
    /* 250 */ "書式仕様の誤り：　'.'、'-'または'+'の後に数の指定がありません",
    /* 251 */ "書式仕様の文字列中に不当な文字があります",
    /* 252 */ "ファイルの終わり以降に対する操作があります",
    /* 253 */ "直接探査で存在しないレコードの入力があります",
    /* 254 */ "書式仕様中の反復仕様が不当です",
};