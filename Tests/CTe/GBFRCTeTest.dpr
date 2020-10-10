program GBFRCTeTest;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}
{$STRONGLINKTYPES ON}
{$R *.dres}

uses
  System.SysUtils,
  Winapi.ActiveX,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ELSE}
  DUnitX.Loggers.Console,
  {$ENDIF }
  DUnitX.TestFramework,
  GBFR.CTe.Test.Base in 'GBFR.CTe.Test.Base.pas',
  GBFR.CTe.Model in '..\..\Source\CTe\GBFR.CTe.Model.pas',
  GBFR.CTe.Model.Ide in '..\..\Source\CTe\GBFR.CTe.Model.Ide.pas',
  GBFR.CTe.Model.Types in '..\..\Source\CTe\GBFR.CTe.Model.Types.pas',
  GBFR.CTe.Model.Classes in '..\..\Source\CTe\GBFR.CTe.Model.Classes.pas',
  GBFR.CTe.XML.Interfaces in '..\..\Source\CTe\GBFR.CTe.XML.Interfaces.pas',
  GBFR.CTe.XML.Default in '..\..\Source\CTe\GBFR.CTe.XML.Default.pas',
  GBFR.XML.Base in '..\..\Source\XML\GBFR.XML.Base.pas',
  System.Classes,
  GBFR.CTe.Model.Ide.Toma3 in '..\..\Source\CTe\GBFR.CTe.Model.Ide.Toma3.pas',
  GBFR.CTe.Model.Ide.Toma4 in '..\..\Source\CTe\GBFR.CTe.Model.Ide.Toma4.pas';

//
{$IFNDEF TESTINSIGHT}
var
  runner: ITestRunner;
  results: IRunResults;
  logger: ITestLogger;
  nunitLogger : ITestLogger;
{$ENDIF}
begin
  ReportMemoryLeaksOnShutdown := True;
  CoInitialize(nil);
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
{$ELSE}
  try
    //Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;
    //Create the test runner
    runner := TDUnitX.CreateRunner;
    //Tell the runner to use RTTI to find Fixtures
    runner.UseRTTI := True;
    //When true, Assertions must be made during tests;
    runner.FailsOnNoAsserts := False;

    //tell the runner how we will log things
    //Log to the console window if desired
    if TDUnitX.Options.ConsoleMode <> TDunitXConsoleMode.Off then
    begin
      logger := TDUnitXConsoleLogger.Create(TDUnitX.Options.ConsoleMode = TDunitXConsoleMode.Quiet);
      runner.AddLogger(logger);
    end;
    //Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);

    //Run tests
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

    {$IFNDEF CI}
    //We don't want this happening when running under CI.
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
    {$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
{$ENDIF}
  CoUninitialize;
end.
