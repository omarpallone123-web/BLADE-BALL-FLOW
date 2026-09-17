local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
function yBZxMFrgdQAPkfloqZtpSsGHmfQNNnkJvRMWrbUU(data) m=string.sub(data, 0, 55) data=data:gsub(m,'')

data = string.gsub(data, '[^'..b..'=]', '') return (data:gsub('.', function(x) if (x == '=') then return '' end local r,f='',(b:find(x)-1) for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end return r; end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x) if (#x ~= 8) then return '' end local c=0 for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end return string.char(c) end)) end


 


local WindUI = loadstring(game:HttpGet(yBZxMFrgdQAPkfloqZtpSsGHmfQNNnkJvRMWrbUU('rjTTUivtaMfbWeGRiWXNYoEdiNGAIKvHGGBYALqPLWDZjdQeshyGMdwaHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0Zvb3RhZ2VzdXMvV2luZFVJL21haW4vZGlzdC9tYWluLmx1YQ==')))()

-- COMPLETE KEY SYSTEM CONFIGURATION
local RAW_KEY_URL = yBZxMFrgdQAPkfloqZtpSsGHmfQNNnkJvRMWrbUU('eNYbnKASrfYdcwNLuJGWiJCWuQyOSiKnoXFavneOiDMItqwYsDxRjcGaHR0cHM6Ly9wYXN0ZWJpbi5jb20vcmF3L1RHRGtpSzg0')
local LINKVERTISE_URL = yBZxMFrgdQAPkfloqZtpSsGHmfQNNnkJvRMWrbUU('ORJSlQEQLWvfwQbWtDQMYJJsusBptRQSofIkVMVRLgdxkVSxusKDppAaHR0cHM6Ly9saW5rLWh1Yi5uZXQvOTQ0NDg5Mi9SZXpxN1lydENXOEE=')
local SCRIPT_URL = yBZxMFrgdQAPkfloqZtpSsGHmfQNNnkJvRMWrbUU('wUBCSOtceTtPKtiJlTUpDbyNbjWYufYgsEyhsnEARhYhvFUgOkojdmkaHR0cHM6Ly9wYXN0ZWJpbi5jb20vcmF3LzdEVW5reVNV')

local KeyWindow = WindUI:CreateWindow({
    Title = yBZxMFrgdQAPkfloqZtpSsGHmfQNNnkJvRMWrbUU('rJPpWBtFUQoODOBEQkYviTmyyPkUyDcMhiVuJXEhgEiiizFseDNpDoZRmxvdyBIdWIgVjMgLSBLZXkgU3lzdGVt'),
    Icon = yBZxMFrgdQAPkfloqZtpSsGHmfQNNnkJvRMWrbUU('ENfTzBahqpaoJRmJISWTUatqxhsgOheKCtuzhCnhgxORVDiXOLSPNwSa2V5'),
    Author = yBZxMFrgdQAPkfloqZtpSsGHmfQNNnkJvRMWrbUU('QUachIdyPaZfcUhAWWDcPkBxnTxmsTVMaiIegTmfPZYAZqIdoLAfFsuRmxvdyBUZWFt')
})

local KeyTab = KeyWindow:Tab({ Title = yBZxMFrgdQAPkfloqZtpSsGHmfQNNnkJvRMWrbUU('BGEwmlYVAXDbzRNVWUhHXsoegFTwavCnogykRdHmJmTQMezijORrcNNQXV0aGVudGljYXRpb24='), Icon = yBZxMFrgdQAPkfloqZtpSsGHmfQNNnkJvRMWrbUU('idokdiaSPvwFIHDiUqgNsZlKCbVQWedZNVELPHZdVRJPziuzYJGaFUibG9jaw==') })
local enteredKey = yBZxMFrgdQAPkfloqZtpSsGHmfQNNnkJvRMWrbUU('HXFireYtyAGPjSCNiCGyUOqqpvFoAhydgEShuROyVsEeZHgdXXbqZUO')

KeyTab:Input({
    Title = yBZxMFrgdQAPkfloqZtpSsGHmfQNNnkJvRMWrbUU('tpQwHXPlblpluLVEIfufOpMlwTOckuzdNmCxVQazkReeZfUcNPDwOglRW50ZXIgS2V5'),
    Placeholder = yBZxMFrgdQAPkfloqZtpSsGHmfQNNnkJvRMWrbUU('WxXWELwLmBVdUzqUZCuGMPtwJKhYdIikEBXiAwNyCJchKNFdqyEKoxIUGFzdGUgeW91ciBrZXkgaGVyZS4uLg=='),
    Callback = function(v)
        enteredKey = string.gsub(v, yBZxMFrgdQAPkfloqZtpSsGHmfQNNnkJvRMWrbUU('gvlWVdbmcXbpKgfLUyEIJycEYwenBSxXXnoPlmclkoBOVVWtMGuFwNXJXMr'), yBZxMFrgdQAPkfloqZtpSsGHmfQNNnkJvRMWrbUU('oQAwKjgBrqAyOGecrqJBUMejJmwiXYYjjbqgDiAgUbeHovDKyydyOWL'))
    end
})

KeyTab:Button({
    Title = yBZxMFrgdQAPkfloqZtpSsGHmfQNNnkJvRMWrbUU('HTyLZeJINcNjSuzjfNRqyXrqtvbTXBlvldETRNnegNEQWarRWEZGkfxR2V0IEtleSAoTGlua3ZlcnRpc2Up'),
    Callback = function()
        if setclipboard then
            setclipboard(LINKVERTISE_URL)
            WindUI:Notify({ Title = yBZxMFrgdQAPkfloqZtpSsGHmfQNNnkJvRMWrbUU('thFTwpuXKCoLgCKPpuzczYYFwwYGQOoMaxTQAIjLtjcPrMMeHYRdrpxTGlua3ZlcnRpc2U='), Content = yBZxMFrgdQAPkfloqZtpSsGHmfQNNnkJvRMWrbUU('JMLiwZFTUUbTKoxRVTGNQfNVEyBplcwozFFgeAXsZEOcFWxSaaiCUZBTGluayBjb3BpZWQgdG8gY2xpcGJvYXJkISBQYXN0ZSBpdCBpbnRvIHlvdXIgYnJvd3Nlci4='), Duration = 4 })
        else
            WindUI:Notify({ Title = yBZxMFrgdQAPkfloqZtpSsGHmfQNNnkJvRMWrbUU('JrRvxLnEiQBiAyIrtPqWMzyHmRSirMtWQPbRIGSyikewwlVTIiRyXeiS2V5IExpbms='), Content = LINKVERTISE_URL, Duration = 6 })
        end
    end
})

KeyTab:Button({
    Title = yBZxMFrgdQAPkfloqZtpSsGHmfQNNnkJvRMWrbUU('BScKbYcNYCJTZutPQtKLoUkyCHEQlTFnUffyLPxlgxnNUGFgAolqBBUVmVyaWZ5IEtleQ=='),
    Callback = function()
        local success, fetchedKey = pcall(function()
            return game:HttpGet(RAW_KEY_URL)
        end)
        
        if success and fetchedKey then
            local correctKey = string.gsub(fetchedKey, yBZxMFrgdQAPkfloqZtpSsGHmfQNNnkJvRMWrbUU('PgkDhrsjByEEBnyCVwCzsWYBPfLYvpvazchKLBMOFyIMUXTsLrLbnZkJXMr'), yBZxMFrgdQAPkfloqZtpSsGHmfQNNnkJvRMWrbUU('DgJFanRppUtFThcnOOvJgnZlnMZxJUNltSMpaSzocDqtOZuksyUqYPj'))
            
            if enteredKey ~= yBZxMFrgdQAPkfloqZtpSsGHmfQNNnkJvRMWrbUU('sPAQVoDLYlqsgmKBQuDjJGmpbtbaQPIAkeCEnWXaGIwBJPekNVJgABN') and enteredKey == correctKey then
                WindUI:Notify({ Title = yBZxMFrgdQAPkfloqZtpSsGHmfQNNnkJvRMWrbUU('vlLZzGQCPZQharvJUBoeMtjTlayyaClLMCoGvTYEoeUAvwUnKGaAlCtQWNjZXNzIEdyYW50ZWQ='), Content = yBZxMFrgdQAPkfloqZtpSsGHmfQNNnkJvRMWrbUU('AMLwDTpDftPOxuCewCkmPTqDMyLdMReDqPWeHWUigkGJeOWmhdIwqJvVmFsaWQgS2V5ISBMb2FkaW5nIEZsb3cgSHViIFYzLi4u'), Duration = 2 })
                task.wait(1)
                KeyWindow:Destroy()
                
                -- EXECUTE PASTEBIN SCRIPT AFTER AUTHENTICATION
                loadstring(game:HttpGet(SCRIPT_URL))()
            else
                WindUI:Notify({ Title = yBZxMFrgdQAPkfloqZtpSsGHmfQNNnkJvRMWrbUU('yaaWhzEYKhVCHSyURWUEqbCJZatIBaPPaelbVwBYipKcuqNQkNdTZhSQWNjZXNzIERlbmllZA=='), Content = yBZxMFrgdQAPkfloqZtpSsGHmfQNNnkJvRMWrbUU('OwanYXFkTkIvqmJXfRrBPebdFXiZksKAJBIloehbeGVZfoEHILUoWngSW52YWxpZCBvciBpbmNvcnJlY3Qga2V5IQ=='), Duration = 3 })
            end
        else
            WindUI:Notify({ Title = yBZxMFrgdQAPkfloqZtpSsGHmfQNNnkJvRMWrbUU('sdJeIhidiKLlELYaqHeMipmKbUTwfhrECdIhknWxNMDNMrYqyfXARHaU2VydmVyIEVycm9y'), Content = yBZxMFrgdQAPkfloqZtpSsGHmfQNNnkJvRMWrbUU('CMIzkzjSswKcmWUXPinnHjaBYOCvNeASbIVNvbvLhGItKjNpJrRCHQCRmFpbGVkIHRvIGZldGNoIGtleSBvbmxpbmUu'), Duration = 3 })
        end
    end
})
    
