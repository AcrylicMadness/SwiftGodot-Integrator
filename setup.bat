git clone https://github.com/AcrylicMadness/SwiftGodot-Integrator
CD "SwiftGodot-Integrator"
swift build --configuration release
FOR /F "tokens=*" %%g IN ('swift build --configuration release --show-bin-path') do (
    SET BIN_PATH=%%g\sgint.exe
)
CD ../
COPY "%BIN_PATH%" .
RMDIR /S /Q "SwiftGodot-Integrator"