object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Calculator of expression'
  ClientHeight = 700
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = CloseEvent
  OnCloseQuery = mainCloseQuery
  OnCreate = mainCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageCtrlMain: TPageControl
    Left = 0
    Top = 0
    Width = 800
    Height = 700
    ActivePage = tabGraph
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    MultiLine = True
    ParentFont = False
    TabOrder = 0
    TabWidth = 200
    ExplicitWidth = 784
    ExplicitHeight = 649
    object TabFileEnter: TTabSheet
      Caption = 'File Input'
      ImageIndex = 2
      object lblState: TLabel
        Left = 72
        Top = 56
        Width = 135
        Height = 24
        Align = alCustom
        Alignment = taCenter
        Caption = 'no file selected'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object btnChooseFile: TButton
        Left = 72
        Top = 145
        Width = 129
        Height = 65
        Caption = 'Choose file'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = btnChooseFileClick
      end
      object btnNextExpr: TButton
        Left = 232
        Top = 145
        Width = 129
        Height = 65
        Caption = 'Read next'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = btnNextExprClick
      end
      object btnToCalc: TButton
        Left = 392
        Top = 145
        Width = 129
        Height = 65
        Caption = 'To calculator'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = btnToCalcClick
      end
      object btnToGraph: TButton
        Left = 552
        Top = 145
        Width = 129
        Height = 65
        Caption = 'To graph'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = btnToGraphClick
      end
    end
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
        Left = 29
        Top = 37
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
        Top = 3
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
      object lblGraphAns: TLabel
        Left = 16
        Top = 80
        Width = 6
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object imgGraph: TPaintBox
        Left = 45
        Top = 180
        Width = 700
        Height = 450
      end
      object lblDown3: TLabel
        Left = 368
        Top = 636
        Width = 4
        Height = 16
      end
      object lblDown4: TLabel
        Left = 573
        Top = 636
        Width = 4
        Height = 16
      end
      object lblDown2: TLabel
        Left = 208
        Top = 636
        Width = 4
        Height = 16
      end
      object lblUp2: TLabel
        Left = 208
        Top = 149
        Width = 4
        Height = 16
      end
      object lblUp3: TLabel
        Left = 368
        Top = 149
        Width = 4
        Height = 16
      end
      object lblUp4: TLabel
        Left = 573
        Top = 149
        Width = 4
        Height = 16
      end
      object lblDown5: TLabel
        Left = 728
        Top = 636
        Width = 4
        Height = 16
      end
      object lblUp5: TLabel
        Left = 728
        Top = 149
        Width = 4
        Height = 16
        BiDiMode = bdLeftToRight
        ParentBiDiMode = False
      end
      object lblDown1: TLabel
        Left = 40
        Top = 636
        Width = 4
        Height = 16
      end
      object lblUp1: TLabel
        Left = 40
        Top = 149
        Width = 4
        Height = 16
      end
      object btnDraw: TButton
        Left = 640
        Top = 34
        Width = 121
        Height = 32
        Caption = 'draw'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = btnDrawClick
      end
      object btnGraphUp: TButton
        Left = 616
        Top = 448
        Width = 50
        Height = 50
        Caption = #9#9650
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        Visible = False
        OnClick = btnGraphUpClick
      end
      object btnGraphDown: TButton
        Left = 616
        Top = 560
        Width = 50
        Height = 50
        Caption = #9#9660
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        Visible = False
        OnClick = btnGraphDownClick
      end
      object btnGraphLeft: TButton
        Left = 560
        Top = 504
        Width = 50
        Height = 50
        Caption = #9668
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        Visible = False
        OnClick = btnGraphLeftClick
      end
      object btnGraphRight: TButton
        Left = 672
        Top = 504
        Width = 50
        Height = 50
        Caption = #9658
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        Visible = False
        OnClick = btnGraphRightClick
      end
      object btnIncScale: TButton
        Left = 80
        Top = 476
        Width = 50
        Height = 50
        Caption = '+'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        Visible = False
        OnClick = btnIncScaleClick
      end
      object btnDecScale: TButton
        Left = 80
        Top = 548
        Width = 50
        Height = 50
        Caption = '-'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
        Visible = False
        OnClick = btnDecScaleClick
      end
      object editEnterFunc: TEdit
        Left = 72
        Top = 34
        Width = 554
        Height = 32
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 7
        Text = 'Enter your function'
      end
    end
  end
  object OpenTextFileDialog: TOpenTextFileDialog
    Filter = 'txt file|*.txt'
    Left = 748
    Top = 35
  end
end
