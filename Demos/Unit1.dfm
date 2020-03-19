object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 460
  ClientWidth = 521
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 438
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object StringGrid1: TStringGrid
    Left = 32
    Top = 32
    Width = 369
    Height = 225
    ColCount = 1
    FixedCols = 0
    RowCount = 2
    TabOrder = 1
  end
  object DBGrid1: TDBGrid
    Left = 32
    Top = 280
    Width = 369
    Height = 145
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object SSQL1: TSSQL
    TunnelUrl = 'http://localhost/AHE/koneksi/konek.php'
    Token = '53713'
    Host = 'localhost'
    User = 'root'
    Database = 'fujioozx'
    Left = 376
    Top = 32
  end
  object Mem: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvPersistent, rvSilentMode]
    ResourceOptions.Persistent = True
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 440
    Top = 392
  end
  object BindSourceDB1: TBindSourceDB
    ScopeMappings = <>
    Left = 408
    Top = 224
  end
  object BindingsList1: TBindingsList
    Methods = <>
    OutputConverters = <>
    Left = 20
    Top = 5
    object LinkGridToDataSourceBindSourceDB2: TLinkGridToDataSource
      Category = 'Quick Bindings'
      DataSource = BindSourceDB2
      GridControl = StringGrid1
      Columns = <>
    end
  end
  object BindSourceDB2: TBindSourceDB
    DataSet = Mem
    ScopeMappings = <>
    Left = 264
    Top = 224
  end
end
