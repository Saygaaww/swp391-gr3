$files = Get-ChildItem -Path "c:\Users\tenma\Downloads\swp391-gr3-dung-merge-hao-borrow\web" -Recurse -Filter *.jsp
foreach ($file in $files) {
    try {
        $content = Get-Content $file.FullName -Raw
        if ($null -ne $content) {
            $changed = $false
            
            if ($content -match "http://java.sun.com/jsp/jstl/core") {
                $content = $content.Replace("http://java.sun.com/jsp/jstl/core", "jakarta.tags.core")
                $changed = $true
            }
            if ($content -match "http://java.sun.com/jsp/jstl/fmt") {
                $content = $content.Replace("http://java.sun.com/jsp/jstl/fmt", "jakarta.tags.fmt")
                $changed = $true
            }
            if ($content -match "http://java.sun.com/jsp/jstl/functions") {
                $content = $content.Replace("http://java.sun.com/jsp/jstl/functions", "jakarta.tags.functions")
                $changed = $true
            }
            
            if ($changed) {
                Set-Content -Path $file.FullName -Value $content -Encoding UTF8
                Write-Host "Updated $($file.Name)"
            }
        }
    } catch {
        Write-Host "Error processing $($file.Name): $_"
    }
}
Write-Host "Migration complete."
