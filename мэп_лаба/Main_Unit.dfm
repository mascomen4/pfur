object Form1: TForm1
  Left = 0
  Top = 0
  Caption = #1063#1090#1077#1085#1080#1077'-'#1079#1072#1087#1080#1089#1100' '#1080#1079'/'#1074' '#1090#1077#1082#1089#1090#1086#1074#1099#1081' '#1092#1072#1081#1083
  ClientHeight = 468
  ClientWidth = 632
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 429
    Height = 468
    Align = alClient
    TabOrder = 0
    object Image1: TImage
      Left = 1
      Top = 1
      Width = 427
      Height = 466
      Align = alClient
      ExplicitLeft = 104
      ExplicitTop = 96
      ExplicitWidth = 105
      ExplicitHeight = 105
    end
  end
  object Panel1: TPanel
    Left = 429
    Top = 0
    Width = 203
    Height = 468
    Align = alRight
    TabOrder = 1
    object Label1: TLabel
      Left = 32
      Top = 48
      Width = 98
      Height = 13
      Caption = #1044#1083#1080#1085#1072' '#1076#1091#1075#1080' '#1082#1088#1080#1074#1086#1081
    end
    object Curve_Length: TLabel
      Left = 40
      Top = 88
      Width = 68
      Height = 13
      Caption = 'Curve_Length'
    end
    object btDrawGraph: TButton
      Left = 37
      Top = 292
      Width = 121
      Height = 25
      Caption = 'Draw Graphics'
      TabOrder = 0
      OnClick = btDrawGraphClick
    end
    object btsavedata: TBitBtn
      Left = 37
      Top = 323
      Width = 121
      Height = 20
      Caption = #1047#1072#1087#1080#1089#1100' '#1074' '#1092#1072#1081#1083
      TabOrder = 1
      OnClick = btsavedataClick
    end
    object btReadData: TBitBtn
      Left = 21
      Top = 266
      Width = 156
      Height = 20
      Caption = #1063#1090#1077#1085#1080#1077' '#1076#1072#1085#1085#1099#1093' '#1080#1079' '#1092#1072#1081#1083#1072
      TabOrder = 2
      OnClick = btReadDataClick
    end
  end
end
