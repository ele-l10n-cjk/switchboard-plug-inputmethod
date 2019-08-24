/*
* Copyright (c) 2019 Ryo Nakano
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

namespace InputMethod {
    public enum InstallList {
        JA,
        KO,
        ZH_CN,
        ZH_HK,
        ZH_SG,
        ZH_TW;

        public string get_name () {
            switch (this) {
                case JA:
                    return _("Japanese");
                case KO:
                    return _("Korean");
                case ZH_CN:
                    return _("Chinese (China)");
                case ZH_HK:
                    return _("Chinese (Hong Kong)");
                case ZH_SG:
                    return _("Chinese (Singapore)");
                case ZH_TW:
                    return _("Chinese (Taiwan)");
                default:
                    assert_not_reached ();
            }
        }

        public string get_lang_code () {
            switch (this) {
                case JA:
                    return "ja";
                case KO:
                    return "ko";
                case ZH_CN:
                    return "zh_CN";
                case ZH_HK:
                    return "zh_HK";
                case ZH_SG:
                    return "zh_SG";
                case ZH_TW:
                    return "zh_TW";
                default:
                    assert_not_reached ();
            }
        }

        public string[] get_components () {
            switch (this) {
                case JA:
                    return { "ibus-mozc" };
                case KO:
                    return { "ibus-hangul" };
                case ZH_CN:
                    return { "ibus-pinyin" };
                case ZH_HK:
                    return { "ibus-cangjie" };
                case ZH_SG:
                    return { "ibus-pinyin" };
                case ZH_TW:
                    return { "ibus-chewing" };
                default:
                    assert_not_reached ();
            }
        }

        public static InstallList[] get_all () {
            return { JA, KO, ZH_CN, ZH_HK, ZH_SG, ZH_TW };
        }
    }
}
