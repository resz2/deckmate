function UUID()
    local fn = function(x)
        local r = love.math.random(16) - 1
        r = (x == "x") and (r + 1) or (r % 4) + 9
        return ("0123456789abcdef"):sub(r, r)
    end
    return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"):gsub("[xy]", fn))
end

function random_real(n1, n2)
    -- returns random real number between n1 and n2, values can be -ve
    -- if n2 is not provided, returns random real number between 0 and n1
    if not n2 then
        return love.math.random()*n1
    else
        if n1 > n2 then n1, n2 = n2, n1 end
        return love.math.random()*(n2 - n1) + n1
    end
end