unit uCore;

interface
{A Component to connect MySQL via HTTP Protocol
Note that the component is under development, the security is not considered yet
Contributor : Didi Kurniadi}
uses
  System.Net.HttpClientComponent, System.Net.Mime,
  System.JSON, System.Net.URLClient, System.Net.HttpClient,FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,SysUtils,Classes,DB,IniFiles, REST.Types,
  REST.Response.Adapter, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, FireDAC.DApt,FMX.DialogService;
type
TSSQL = Class(TComponent)
 Private
   FLoadUrl : string;
   FPostUrl : string;
   FToken   : string;
   FMemDataSet : TFDMemTable;
   Fhost : string;
   FUser : string;
   FPass : String;
   FDatabase : string;

   function SQLtoDataSet(aSQL:string):TFDMemTable;
   procedure SetLoadUrl(Const Urls : string);
   procedure SetPostUrl(Const Urls : string);
   procedure SetMemTable(FDataSet:TFDMemTable);
   procedure SetSQL(fSQL : TStringList);
   procedure SetToken (SToken : string);
   procedure SetHost (SHost : string);
   procedure SetUser (SUser : string);
   procedure SetPass (Spass : string);
   procedure SetDatabase (SDatabase : string);


 public
   LastError : string;
   aSQL : TStringList;
   SToken : string;
   statcode : integer;
   constructor Create(AOwner: TComponent); override;
   destructor  Destroy; override;


 published
   function ExecSQL(aSQL : string): boolean;
   function LoadX(aSQL : string; Response : TStringStream): TStringStream;
   procedure Open;
   property TunnelUrl : string read FLoadUrl write SetLoadUrl;
   property MemDataSet : TFDMemTable read FMemDataSet write FMemDataSet;
   property SQL : TStringList read aSQL write SetSQL;
   property Token : string read FToken write SetToken;
   property Host : string read FHost write SetHost;
   property User : string read FUser write SetUser;
   property Password : string read FPass write SetPass;
   property Database : string read FDataBase write SetDataBase;
end;

procedure Register;
var

FHTTP   : TNetHTTPClient;
aRespon : Tstringstream;

implementation

{TSSQL}

procedure TSSQL.SetHost(SHost: string);
begin
FHost := SHost;
end;

procedure TSSQL.SetToken (SToken : string);
begin
 FToken := SToken;
end;

procedure TSSQL.SetUser (SUser : string);
begin
 FUser := SUser;
end;

procedure TSSQL.SetPass (SPass : string);
begin
 FPass := SPass;
end;

procedure TSSQL.SetDatabase (SDatabase : string);
begin
 FDatabase := SDatabase;
end;

procedure Register;
begin
  RegisterComponents('Dikrama', [TSSQL]);
end;

constructor TSSQL.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHTTP  := TNetHTTPClient.Create(Self);
  aRespon := TStringStream.Create;
  aSQL := TStringList.Create;
  //FMemDataSet := TFDMemTable.Create(self);
end;

destructor  TSSQL.Destroy;
begin
  try

  except

  end;
  inherited Destroy;
end;

function TSSQL.LoadX(aSQL : string; Response : TStringStream): TStringStream;
var
  param : TMultiPartFormData;
begin
try
  param := TMultiPartFormData.Create;
  param.AddField('par',aSQL);
  param.AddField('tokenid',FToken);
  response.Clear;
  fHttp.Post(TunnelUrl,param,Response);
  if statcode=200 then result:=Response else result := Response;
except
  result := Response;
end;
end;

procedure TSSQL.SetPostUrl(Const Urls : string);
begin
FPostUrl := Urls;
end;

procedure TSSQL.SetLoadUrl(Const Urls : string);
begin
FLoadUrl := Urls;
end;

procedure TSSQL.SetSQL(fSQL : TStringList);
begin
  fSQL := TStringList.Create;
  aSQL.Text := fSQL.Text;
end;

procedure TSSQL.SetMemTable(FDataSet: TFDMemTable);
begin
   FDataSet := TFDMemTable.Create(self);
   FDataSet := FMemDataSet;
end;

function TSSQL.ExecSQL(aSQL : string): boolean;
var
param : TMultiPartFormData;
begin
  try
    param := TMultiPartFormData.Create;
    param.AddField('tokenid',FToken);
    param.AddField('par',aSQL);
    param.AddField('host',FHost);
    param.AddField('user',FUser);
    param.AddField('pass',FPass);
    param.AddField('DB',FDataBase);

    fhttp.Post(TunnelUrl,param,aRespon);
    if (statcode=200) or (Pos('Error description',aRespon.DataString)=0) then result:=true else result := false;
  finally
    param.Free;
  end;
end;

function TSSQL.SQLtoDataSet(aSQL:string):TFDMemTable;
var
  Req : TRestRequest;
  Client : TRESTClient;
  Res : TRESTResponse;
  Adapt : TRESTResponseDataSetAdapter;
begin
try
    try
      Req := TRestRequest.Create(Self);
      Client := TRESTClient.Create(Self);
      Res := TRESTResponse.Create(Self);
      Adapt := TRESTResponseDataSetAdapter.Create(Self);

      MemDataSet.Close;
      MemDataSet.Fields.Clear;

      Client.BaseURL := TunnelUrl;
      Req.Client := Client;
      Req.Response := Res;
      Adapt.ResponseJSON := Res;
      Adapt.Dataset := MemDataSet;

      Req.Method := rmPOST;
      Client.Params.AddItem;
      Client.Params[0].Name := 'tokenid';
      Client.Params[0].Value := FToken;
      Client.Params.AddItem;
      Client.Params[1].Name := 'par';
      Client.Params[1].Value := aSQL;
      Client.Params.AddItem;
      Client.Params[2].Name := 'host';
      Client.Params[2].Value := FHost;
      Client.Params.AddItem;
      Client.Params[3].Name := 'user';
      Client.Params[3].Value := FUser;
      Client.Params.AddItem;
      Client.Params[4].Name := 'pass';
      Client.Params[4].Value := FPass;
      Client.Params.AddItem;
      Client.Params[5].Name := 'DB';
      Client.Params[5].Value := FDatabase;

      Req.Execute;

    except
        On E : Exception do begin LastError := E.Message;        
                            end;
        end;

finally
  //Req.Free;
  //Client.Free;
  //Res.Free;
  //Adapt.Free;
  //req.Params.Clear;

end;
end;

procedure TSSQL.Open;
begin
if SQL.Text <>'' then
	begin
  if pos('select',SQL.Text)=0 then
     begin
        ExecSQL(SQL.Text);
     end else
     begin
        SQLtoDataSet(SQL.Text);
     end;
	end
	 else ;
end;

end.
