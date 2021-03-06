unit NV.VCL.Page;

interface

uses
  Classes, RTLConsts, Controls, NV.VCL.Container, NV.DispatcherPage;

type
  TNVPageClass = class of TNVBasepage;

  //base for all pages
  TNVBasePage = class(TNVModuleContainer)
  private
    FRouteName: string;
    FDispatcher: TDispatchPage;
    procedure SetRouteName(const Value: string);
    procedure SetDispatcher(const Value: TDispatchPage);
    function GetDispatcher: TDispatchPage;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AfterConstruction; override;
    property Dispatcher: TDispatchPage read GetDispatcher write SetDispatcher;
    property RouteName: string read FRouteName write SetRouteName;
  end;

  TNVPage = class(TNVBasepage)
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Dispatcher;
    property RouteName;
  end;

implementation

uses
  NV.Session;

type
  THackSession = class(TNVSessionApp);


{ TNVBasePage }

procedure TNVBasePage.AfterConstruction;
var
  _SessionTh: TNVSessionThread;
begin
  inherited;
  if TNVSessionThread.GetCurrent(_SessionTh) then
    THackSession(_SessionTh.SessionApp).AddPage(Self);
end;

constructor TNVBasePage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
 // FlowDesign:=True;
  //FRouteName:= Name;
  ControlStyle := ControlStyle + [csAcceptsControls];
  if ((ClassType <> TNVBasePage) and (ClassType <> TNVPage)) and not (csDesignInstance in ComponentState) then
  begin
    if not InitInheritedComponent(Self, TNVBasePage) then
      raise EResNotFound.CreateFmt(SResNotFound, [ClassName]);
  end
  else
  begin
    Width := 320;
    Height := 240;
  end;
 // FHTMLPage := TDWHTMLPage.Create(Self);
  // to avoid store FHTMLPage to dfm
 // if csDesigning in ComponentState then
 //   begin
 //     RemoveComponent(FHTMLPage);
  //  end;
 // FHTMLPage.Name := 'HTMLPage';
end;

function TNVBasePage.GetDispatcher: TDispatchPage;
begin
  if not Assigned(FDispatcher) then
    FDispatcher := TDispatchPage.Create(Self);
  Result := FDispatcher;
end;

procedure TNVBasePage.SetDispatcher(const Value: TDispatchPage);
begin
  FDispatcher := Value;
end;

procedure TNVBasePage.SetRouteName(const Value: string);
begin
  FRouteName := Value;
end;

{ TNVPage }

constructor TNVPage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  RouteName := '/index.html';
end;

end.

