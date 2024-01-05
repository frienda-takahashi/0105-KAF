iPhoneのソフトウェアキーボードのアニメーションに追従するビューシステムです。<br>
クロスプラットフォームの基本コードはC言語、iOS互換レイヤーはObjective-Cで書いてあります。<br>
起動するとヘッダー・ボディ・フッターが表示され、SUB-BARボタンの押下でサブバーが表示されます。<br>
KAFにAdd/Setした全てのビューはキーボードの表示/非表示に追従してフレームが変更されます。<br>
ヘッダーとサブバーは追加しなくても良いですが、フッターにはキーボードを非表示にする機能が有るので追加した方が良いでしょう。<br>
簡易な統合テキストビュー(TEXT)とボタン、バーの実装例を含めてあります。<br>
TEXTは生成時にTEXT_TYPEを指定することでラベル・テキストフィールド・テキストビューを切り替えることができます。<br>
MITライセンスで改変自由・商用利用可です。