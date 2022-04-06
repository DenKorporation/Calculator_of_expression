object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Calculator of expression'
  ClientHeight = 409
  ClientWidth = 821
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageCtrlMain: TPageControl
    Left = 0
    Top = 0
    Width = 821
    Height = 409
    ActivePage = tabCalc
    Align = alClient
    TabOrder = 0
    object tabCalc: TTabSheet
      Caption = 'Calculator'
      object lblAnswer: TLabel
        Left = 48
        Top = 151
        Width = 8
        Height = 33
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object lblHead: TLabel
        Left = 232
        Top = 24
        Width = 196
        Height = 33
        Alignment = taCenter
        Caption = 'This is calculator'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object btnCalculate: TButton
        Left = 671
        Top = 88
        Width = 75
        Height = 41
        Caption = '='
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = btnCalculateClick
      end
      object editEnterExpression: TEdit
        Left = 48
        Top = 88
        Width = 617
        Height = 41
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        Text = 'Enter your expression'
      end
    end
    object tabGraph: TTabSheet
      Caption = 'Graph'
      ImageIndex = 1
    end
  end
end
