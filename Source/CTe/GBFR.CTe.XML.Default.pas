unit GBFR.CTe.XML.Default;

interface

uses
  GBFR.CTe.Model.Classes,
  GBFR.CTe.Model.Types,
  GBFR.CTe.XML.Interfaces,
  GBFR.XML.Base,
  System.Classes,
  System.SysUtils,
  Xml.XMLIntf,
  Xml.XMLDoc;

type TGBFRCTeXMLDefault = class(TGBFRXmlBase, IGBFRCTeXML)

  private
    FCTe: TGBFRCTeModel;
    [Weak]
    FInfCTe: IXMLNode;

    procedure loadTagInfCte;
    procedure loadTagIde;

  protected
    function loadFromContent(Value: String): TGBFRCTeModel;
    function loadFromFile   (Value: String): TGBFRCTeModel;

  public
    class function New: IGBFRCTeXML;
end;

implementation

{ TGBFRCTeXMLDefault }

function TGBFRCTeXMLDefault.loadFromContent(Value: String): TGBFRCTeModel;
begin
  loadXmlContent(Value);
  Result := TGBFRCTeModel.create;
  try
    FCTe := Result;

    loadTagInfCte;
    loadTagIde;
  except
    Result.Free;
    raise;
  end;
end;

function TGBFRCTeXMLDefault.loadFromFile(Value: String): TGBFRCTeModel;
var
  xmlFile: TStrings;
begin
  xmlFile := TStringList.Create;
  try
    xmlFile.LoadFromFile(Value);
    result := loadFromContent(xmlFile.Text);
  finally
    xmlFile.Free;
  end;
end;

procedure TGBFRCTeXMLDefault.loadTagIde;
var
  nodeIDE : IXMLNode;
begin
  try
    nodeIDE := FInfCTe.ChildNodes.FindNode('ide');

    if Assigned(nodeIDE) then
    begin
      FCTe.ide.tpAmb.fromInteger(GetNodeInt(nodeIDE, 'tpAmb', 2));
      FCTe.ide.tpImp.fromInteger(GetNodeInt(nodeIDE, 'tpImp', 1));
      FCTe.ide.tpEmis.fromInteger(GetNodeInt(nodeIDE, 'tpEmis', 1));
      FCTe.ide.tpCTe.fromInteger(GetNodeInt(nodeIDE, 'tpCTe', 0));
      FCTe.ide.procEmi.fromInteger(GetNodeInt(nodeIDE, 'procEmi', 0));
      FCTe.ide.modal.fromString(GetNodeStr(nodeIDE, 'modal', '00'));
      FCTe.ide.tpServ.fromInteger(GetNodeInt(nodeIDE, 'tpServ', 0));
      FCTe.ide.indIEToma.fromInteger(GetNodeInt(nodeIDE, 'indIEToma', 9));

      FCTe.ide.cUF            := GetNodeStr(nodeIDE, 'cUF');
      FCTe.ide.cCT            := GetNodeStr(nodeIDE, 'cCT');
      FCTe.ide.CFOP           := GetNodeStr(nodeIDE, 'CFOP');
      FCTe.ide.natOp          := GetNodeStr(nodeIDE, 'natOp');
      FCTe.ide.&mod           := GetNodeInt(nodeIDE, 'mod');
      FCTe.ide.serie          := GetNodeStr(nodeIDE, 'serie');
      FCTe.ide.nCT            := GetNodeInt(nodeIDE, 'nCT');
      FCTe.ide.dhEmi          := GetNodeDate(nodeIDE, 'dhEmi');
      FCTe.ide.cDV            := GetNodeStr(nodeIDE, 'cDV');
      FCTe.ide.verProc        := GetNodeStr(nodeIDE, 'verProc');
      FCTe.ide.indGlobalizado := GetNodeStr(nodeIDE, 'indGlobalizado');
      FCTe.ide.cMunEnv        := GetNodeStr(nodeIDE, 'cMunEnv');
      FCTe.ide.xMunEnv        := GetNodeStr(nodeIDE, 'xMunEnv');
      FCTe.ide.UFEnv          := GetNodeStr(nodeIDE, 'UFEnv');
      FCTe.ide.cMunIni        := GetNodeStr(nodeIDE, 'cMunIni');
      FCTe.ide.xMunIni        := GetNodeStr(nodeIDE, 'xMunIni');
      FCTe.ide.UFIni          := GetNodeStr(nodeIDE, 'UFIni');
      FCTe.ide.cMunFim        := GetNodeStr(nodeIDE, 'cMunFim');
      FCTe.ide.xMunFim        := GetNodeStr(nodeIDE, 'xMunFim');
      FCTe.ide.UFFim          := GetNodeStr(nodeIDE, 'UFFim');
      FCTe.ide.retira         := GetNodeBoolInt(nodeIDE, 'retira');
      FCTe.ide.xRetira        := GetNodeStr(nodeIDE, 'xRetira');
    end;
  except
    on e : Exception do
    begin
      e.Message := 'Error on read Tag <ide>: ' + e.Message;
      raise;
    end;
  end;
end;

procedure TGBFRCTeXMLDefault.loadTagInfCte;
var
  node : IXMLNode;
begin
  repeat
    if node = nil then
      node := FXml.DocumentElement
    else
    begin
      if node.ChildNodes.Count = 0 then
      begin
        node := nil;
        break;
      end;
      node := node.ChildNodes.Get(0);
    end;
  until (node = nil) or (node.NodeName = 'infCte');

  if (not Assigned(node)) or (not node.NodeName.Equals( 'infCte' )) then
    raise Exception.CreateFmt('Error on read Tag infCte', []);

  FInfCTe := node;
  FCTe.Id := FInfCTe.Attributes[
end;

class function TGBFRCTeXMLDefault.New: IGBFRCTeXML;
begin
  result := Self.create;
end;

end.
