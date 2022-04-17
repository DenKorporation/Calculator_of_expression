object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Calculator of expression'
  ClientHeight = 649
  ClientWidth = 784
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageCtrlMain: TPageControl
    Left = 0
    Top = 0
    Width = 784
    Height = 649
    ActivePage = tabCalc
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    MultiLine = True
    ParentFont = False
    RaggedRight = True
    TabOrder = 0
    TabWidth = 300
    object tabCalc: TTabSheet
      Caption = 'Calculator'
      object lblAnswer: TLabel
        Left = 48
        Top = 151
        Width = 6
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object lblHeadCalc: TLabel
        Left = 280
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
      object Label1: TLabel
        Left = 288
        Top = 312
        Width = 6
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object btnCalculate: TButton
        Left = 671
        Top = 88
        Width = 66
        Height = 32
        Caption = '='
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
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
        Height = 32
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
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
      object lblY: TLabel
        Left = 16
        Top = 70
        Width = 37
        Height = 24
        Caption = 'y = '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object lblHeadGraph: TLabel
        Left = 296
        Top = 24
        Width = 155
        Height = 33
        Caption = 'This is Graph'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object imgGraph: TImage
        Left = 16
        Top = 160
        Width = 721
        Height = 433
      end
      object lblGraphAns: TLabel
        Left = 16
        Top = 120
        Width = 6
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object editEnterFunc: TEdit
        Left = 56
        Top = 67
        Width = 554
        Height = 32
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        Text = 'Enter your function'
      end
      object btnDraw: TButton
        Left = 616
        Top = 67
        Width = 121
        Height = 32
        Caption = 'draw'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = btnDrawClick
      end
    end
  end
end
