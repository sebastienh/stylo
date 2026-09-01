//
//  CSSFontFamilyKeyword.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-19.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

public enum CSSFontFamilyKeyword: String {
    
    case Serif = "serif"
    case SansSerif = "sans-serif"
    case Cursive = "cursive"
    case Fantasy = "fantasy"
    case Monospace = "monospace"
    
    //
    case AlBayan = "Al Bayan"
    case AlNile = "Al Nile"
    case AlTarikh = "Al Tarikh"
    case AmericanTypewriter = "American Typewriter"
    case AndaleMono = "Andale Mono"
    case Arial = "Arial"
    case ArialBlack = "Arial Black"
    case ArialHebrew = "Arial Hebrew"
    case ArialHebrewScholar = "Arial Hebrew Scholar"
    case ArialNarrow = "Arial Narrow"
    case ArialRoundedMTBold = "Arial Rounded MT Bold"
    case ArialUnicodeMS = "Arial Unicode MS"
    case Athelas = "Athelas"
    case Avenir = "Avenir"
    case AvenirNext = "Avenir Next"
    case AvenirNextCondensed = "Avenir Next Condensed"
    case Ayuthaya = "Ayuthaya"
    case Baghdad = "Baghdad"
    case BanglaMN = "Bangla MN"
    case BanglaSangamMN = "Bangla Sangam MN"
    case BaoliSC = "Baoli SC"
    case Baskerville = "Baskerville"
    case Beirut = "Beirut"
    case BigCaslon = "Big Caslon"
    case Bodoni72 = "Bodoni 72"
    case Bodoni72Oldstyle = "Bodoni 72 Oldstyle"
    case Bodoni72Smallcaps = "Bodoni 72 Smallcaps"
    case BodoniOrnaments = "Bodoni Ornaments"
    case BradleyHand = "Bradley Hand"
    case BrushScriptMT = "Brush Script MT"
    case Chalkboard = "Chalkboard"
    case ChalkboardSE = "Chalkboard SE"
    case Chalkduster = "Chalkduster"
    case Charter = "Charter"
    case Cochin = "Cochin"
    case ComicSansMS = "Comic Sans MS"
    case Copperplate = "Copperplate"
    case CorsivaHebrew = "Corsiva Hebrew"
    case Courier = "Courier"
    case CourierNew = "Courier New"
    case Damascus = "Damascus"
    case DecoTypeNaskh = "DecoType Naskh"
    case DevanagariMT = "Devanagari MT"
    case DevanagariSangamMN = "Devanagari Sangam MN"
    case Didot = "Didot"
    case DINAlternate = "DIN Alternate"
    case DINCondensed = "DIN Condensed"
    case DiwanKufi = "Diwan Kufi"
    case DiwanThuluth = "Diwan Thuluth"
    case EuphemiaUCAS = "Euphemia UCAS"
    case Farah = "Farah"
    case Farisi = "Farisi"
    case Futura = "Futura"
    case GB18030Bitmap = "GB18030 Bitmap"
    case GeezaPro = "Geeza Pro"
    case Geneva = "Geneva"
    case Georgia = "Georgia"
    case GillSans = "Gill Sans"
    case GujaratiMT = "Gujarati MT"
    case GujaratiSangamMN = "Gujarati Sangam MN"
    case GungSeo = "GungSeo"
    case GurmukhiMN = "Gurmukhi MN"
    case GurmukhiMT = "Gurmukhi MT"
    case GurmukhiSangamMN = "Gurmukhi Sangam MN"
    case HannotateSC = "Hannotate SC"
    case HannotateTC = "Hannotate TC"
    case HanziPenSC = "HanziPen SC"
    case HanziPenTC = "HanziPen TC"
    case HeadLineA = "HeadLineA"
    case HeitiSC = "Heiti SC"
    case HeitiTC = "Heiti TC"
    case Helvetica = "Helvetica"
    case HelveticaNeue = "Helvetica Neue"
    case Herculanum = "Herculanum"
    case HiraginoKakuGothicPro = "Hiragino Kaku Gothic Pro"
    case HiraginoKakuGothicProN = "Hiragino Kaku Gothic ProN"
    case HiraginoKakuGothicStd = "Hiragino Kaku Gothic Std"
    case HiraginoKakuGothicStdN = "Hiragino Kaku Gothic StdN"
    case HiraginoMaruGothicPro = "Hiragino Maru Gothic Pro"
    case HiraginoMaruGothicProN = "Hiragino Maru Gothic ProN"
    case HiraginoMinchoPro = "Hiragino Mincho Pro"
    case HiraginoMinchoProN = "Hiragino Mincho ProN"
    case HiraginoSansGB = "Hiragino Sans GB"
    case HoeflerText = "Hoefler Text"
    case Impact = "Impact"
    case InaiMathi = "InaiMathi"
    case IowanOldStyle = "Iowan Old Style"
    case ITFDevanagari = "ITF Devanagari"
    case Kailasa = "Kailasa"
    case KaitiSC = "Kaiti SC"
    case KaitiTC = "Kaiti TC"
    case KannadaMN = "Kannada MN"
    case KannadaSangamMN = "Kannada Sangam MN"
    case Kefa = "Kefa"
    case KhmerMN = "Khmer MN"
    case KhmerSangamMN = "Khmer Sangam MN"
    case KohinoorDevanagari = "Kohinoor Devanagari"
    case Kokonor = "Kokonor"
    case Krungthep = "Krungthep"
    case KufiStandardGK = "KufiStandardGK"
    case LantingheiSC = "Lantinghei SC"
    case LantingheiTC = "Lantinghei TC"
    case LaoMN = "Lao MN"
    case LaoSangamMN = "Lao Sangam MN"
    case LibianSC = "Libian SC"
    case LiHeiPro = "LiHei Pro"
    case LiSongPro = "LiSong Pro"
    case LucidaGrande = "Lucida Grande"
    case Luminari = "Luminari"
    case MalayalamMN = "Malayalam MN"
    case MalayalamSangamMN = "Malayalam Sangam MN"
    case Marion = "Marion"
    case MarkerFelt = "Marker Felt"
    case Menlo = "Menlo"
    case MicrosoftSansSerif = "Microsoft Sans Serif"
    case Mishafi = "Mishafi"
    case MishafiGold = "Mishafi Gold"
    case Monaco = "Monaco"
    case Mshtakan = "Mshtakan"
    case Muna = "Muna"
    case MyanmarMN = "Myanmar MN"
    case MyanmarSangamMN = "Myanmar Sangam MN"
    case MyriadPro = "Myriad Pro"
    case Nadeem = "Nadeem"
    case NanumBrushScript = "Nanum Brush Script"
    case NanumGothic = "Nanum Gothic"
    case NanumMyeongjo = "Nanum Myeongjo"
    case NanumPenScript = "Nanum Pen Script"
    case NewPeninimMT = "New Peninim MT"
    case Noteworthy = "Noteworthy"
    case Optima = "Optima"
    case OriyaMN = "Oriya MN"
    case OriyaSangamMN = "Oriya Sangam MN"
    case Osaka = "Osaka"
    case Palatino = "Palatino"
    case Papyrus = "Papyrus"
    case PCMyungjo = "PCMyungjo"
    case Phosphate = "Phosphate"
    case PilGi = "PilGi"
    case PlantagenetCherokee = "Plantagenet Cherokee"
    case PTMono = "PT Mono"
    case PTSans = "PT Sans"
    case PTSansCaption = "PT Sans Caption"
    case PTSansNarrow = "PT Sans Narrow"
    case PTSerif = "PT Serif"
    case PTSerifCaption = "PT Serif Caption"
    case Raanana = "Raanana"
    case Sana = "Sana"
    case Sathu = "Sathu"
    case SavoyeLET = "Savoye LET"
    case Seravek = "Seravek"
    case ShreeDevanagari714 = "Shree Devanagari 714"
    case SignPainter = "SignPainter"
    case Silom = "Silom"
    case SinhalaMN = "Sinhala MN"
    case SinhalaSangamMN = "Sinhala Sangam MN"
    case Skia = "Skia"
    case SnellRoundhand = "Snell Roundhand"
    case SongtiSC = "Songti SC"
    case SongtiTC = "Songti TC"
    case STFangsong = "STFangsong"
    case STHeiti = "STHeiti"
    case STIXGeneral = "STIXGeneral"
    case STIXIntegralsD = "STIXIntegralsD"
    case STIXIntegralsSm = "STIXIntegralsSm"
    case STIXIntegralsUp = "STIXIntegralsUp"
    case STIXIntegralsUpD = "STIXIntegralsUpD"
    case STIXIntegralsUpSm = "STIXIntegralsUpSm"
    case STIXNonUnicode = "STIXNonUnicode"
    case STIXSizeFiveSym = "STIXSizeFiveSym"
    case STIXSizeFourSym = "STIXSizeFourSym"
    case STIXSizeOneSym = "STIXSizeOneSym"
    case STIXSizeThreeSym = "STIXSizeThreeSym"
    case STIXSizeTwoSym = "STIXSizeTwoSym"
    case STIXVariants = "STIXVariants"
    case STKaiti = "STKaiti"
    case STSong = "STSong"
    case SukhumvitSet = "Sukhumvit Set"
    case Superclarendon = "Superclarendon"
    case Symbol = "Symbol"
    case Tahoma = "Tahoma"
    case TamilMN = "Tamil MN"
    case TamilSangamMN = "Tamil Sangam MN"
    case TeluguMN = "Telugu MN"
    case TeluguSangamMN = "Telugu Sangam MN"
    case Thonburi = "Thonburi"
    case Times = "Times"
    case TimesNewRoman = "Times New Roman"
    case Trattatello = "Trattatello"
    case TrebuchetMS = "Trebuchet MS"
    case Verdana = "Verdana"
    case Waseem = "Waseem"
    case WawatiSC = "Wawati SC"
    case WawatiTC = "Wawati TC"
    case Webdings = "Webdings"
    case WeibeiSC = "Weibei SC"
    case WeibeiTC = "Weibei TC"
    case Wingdings = "Wingdings"
    case Wingdings2 = "Wingdings 2"
    case Wingdings3 = "Wingdings 3"
    case XingkaiSC = "Xingkai SC"
    case YuantiSC = "Yuanti SC"
    case YuGothic = "YuGothic"
    case YuMincho = "YuMincho"
    case YuppySC = "Yuppy SC"
    case YuppyTC = "Yuppy TC"
    case ZapfDingbats = "Zapf Dingbats"
    case Zapfino = "Zapfino"
    case AppleBraille = "Apple Braille"
    case AppleChancery = "Apple Chancery"
    case AppleColorEmoji = "Apple Color Emoji"
    case AppleSDGothicNeo = "Apple SD Gothic Neo"
    case AppleSymbols = "Apple Symbols"
    case AppleGothic = "AppleGothic"
    case AppleMyungjo = "AppleMyungjo"
    
    public static var values: [CSSFontFamilyKeyword] {
        
        return [
        
        .Serif,
        .SansSerif,
        .Cursive,
        .Fantasy,
        .Monospace,
        
        //
        .AlBayan,
        .AlNile,
        .AlTarikh,
        .AmericanTypewriter,
        .AndaleMono,
        .Arial,
        .ArialBlack,
        .ArialHebrew,
        .ArialHebrewScholar,
        .ArialNarrow,
        .ArialRoundedMTBold,
        .ArialUnicodeMS,
        .Athelas,
        .Avenir,
        .AvenirNext,
        .AvenirNextCondensed,
        .Ayuthaya,
        .Baghdad,
        .BanglaMN,
        .BanglaSangamMN,
        .BaoliSC,
        .Baskerville,
        .Beirut,
        .BigCaslon,
        .Bodoni72,
        .Bodoni72Oldstyle,
        .Bodoni72Smallcaps,
        .BodoniOrnaments,
        .BradleyHand,
        .BrushScriptMT,
        .Chalkboard,
        .ChalkboardSE,
        .Chalkduster,
        .Charter,
        .Cochin,
        .ComicSansMS,
        .Copperplate,
        .CorsivaHebrew,
        .Courier,
        .CourierNew,
        .Damascus,
        .DecoTypeNaskh,
        .DevanagariMT,
        .DevanagariSangamMN,
        .Didot,
        .DINAlternate,
        .DINCondensed,
        .DiwanKufi,
        .DiwanThuluth,
        .EuphemiaUCAS,
        .Farah,
        .Farisi,
        .Futura,
        .GB18030Bitmap,
        .GeezaPro,
        .Geneva,
        .Georgia,
        .GillSans,
        .GujaratiMT,
        .GujaratiSangamMN,
        .GungSeo,
        .GurmukhiMN,
        .GurmukhiMT,
        .GurmukhiSangamMN,
        .HannotateSC,
        .HannotateTC,
        .HanziPenSC,
        .HanziPenTC,
        .HeadLineA,
        .HeitiSC,
        .HeitiTC,
        .Helvetica,
        .HelveticaNeue,
        .Herculanum,
        .HiraginoKakuGothicPro,
        .HiraginoKakuGothicProN,
        .HiraginoKakuGothicStd,
        .HiraginoKakuGothicStdN,
        .HiraginoMaruGothicPro,
        .HiraginoMaruGothicProN,
        .HiraginoMinchoPro,
        .HiraginoMinchoProN,
        .HiraginoSansGB,
        .HoeflerText,
        .Impact,
        .InaiMathi,
        .IowanOldStyle,
        .ITFDevanagari,
        .Kailasa,
        .KaitiSC,
        .KaitiTC,
        .KannadaMN,
        .KannadaSangamMN,
        .Kefa,
        .KhmerMN,
        .KhmerSangamMN,
        .KohinoorDevanagari,
        .Kokonor,
        .Krungthep,
        .KufiStandardGK,
        .LantingheiSC,
        .LantingheiTC,
        .LaoMN,
        .LaoSangamMN,
        .LibianSC,
        .LiHeiPro,
        .LiSongPro,
        .LucidaGrande,
        .Luminari,
        .MalayalamMN,
        .MalayalamSangamMN,
        .Marion,
        .MarkerFelt,
        .Menlo,
        .MicrosoftSansSerif,
        .Mishafi,
        .MishafiGold,
        .Monaco,
        .Mshtakan,
        .Muna,
        .MyanmarMN,
        .MyanmarSangamMN,
        .MyriadPro,
        .Nadeem,
        .NanumBrushScript,
        .NanumGothic,
        .NanumMyeongjo,
        .NanumPenScript,
        .NewPeninimMT,
        .Noteworthy,
        .Optima,
        .OriyaMN,
        .OriyaSangamMN,
        .Osaka,
        .Palatino,
        .Papyrus,
        .PCMyungjo,
        .Phosphate,
        .PilGi,
        .PlantagenetCherokee,
        .PTMono,
        .PTSans,
        .PTSansCaption,
        .PTSansNarrow,
        .PTSerif,
        .PTSerifCaption,
        .Raanana,
        .Sana,
        .Sathu,
        .SavoyeLET,
        .Seravek,
        .ShreeDevanagari714,
        .SignPainter,
        .Silom,
        .SinhalaMN,
        .SinhalaSangamMN,
        .Skia,
        .SnellRoundhand,
        .SongtiSC,
        .SongtiTC,
        .STFangsong,
        .STHeiti,
        .STIXGeneral,
        .STIXIntegralsD,
        .STIXIntegralsSm,
        .STIXIntegralsUp,
        .STIXIntegralsUpD,
        .STIXIntegralsUpSm,
        .STIXNonUnicode,
        .STIXSizeFiveSym,
        .STIXSizeFourSym,
        .STIXSizeOneSym,
        .STIXSizeThreeSym,
        .STIXSizeTwoSym,
        .STIXVariants,
        .STKaiti,
        .STSong,
        .SukhumvitSet,
        .Superclarendon,
        .Symbol,
        .Tahoma,
        .TamilMN,
        .TamilSangamMN,
        .TeluguMN,
        .TeluguSangamMN,
        .Thonburi,
        .Times,
        .TimesNewRoman,
        .Trattatello,
        .TrebuchetMS,
        .Verdana,
        .Waseem,
        .WawatiSC,
        .WawatiTC,
        .Webdings,
        .WeibeiSC,
        .WeibeiTC,
        .Wingdings,
        .Wingdings2,
        .Wingdings3,
        .XingkaiSC,
        .YuantiSC,
        .YuGothic,
        .YuMincho,
        .YuppySC,
        .YuppyTC,
        .ZapfDingbats,
        .Zapfino,
        .AppleBraille,
        .AppleChancery,
        .AppleColorEmoji,
        .AppleSDGothicNeo,
        .AppleSymbols,
        .AppleGothic,
        .AppleMyungjo,
        ]
        
    }
    
}
