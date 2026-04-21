local Players = game:GetService("Players")
local player = Players.LocalPlayer

local correctKeys = {
    "X2SX-1234-5678-RRRR-TTTT", -- Admin key
    "S9KX-4TQ7-2MZL-8PWR-6HJD", -- User key 1
    "SB3F-7XQ2-L9VN-5KTR-1ZPM", -- User key 2
    "S7DL-2QWX-8VJN-4RKP-9TGH", -- User key 3
    "SMX2-6QPL-3VKR-9ZWT-5HNF", -- User key 4
    "S4ZT-8KQM-1XVR-6LPD-2JHG", -- User key 5
    "SQ9L-5VXT-7KRP-3ZMN-8HWF", -- User key 6
    "S2XK-9LQV-4TRP-7ZHD-6MJN", -- User key 7
    "SR7P-3KXT-9VQL-2HZN-5MFW", -- User key 8
    "S8QV-1ZKP-6XTR-4LHM-9JWD", -- User key 9
    "ST5X-9QVL-2KRP-8ZMN-3HJF", -- User key 10
    "SX4K-9QTL-2VHM-8RWP-6JND", -- User key 11
    "S7MP-3XQV-9LKT-2HZR-5WNF", -- User key 12
    "SK9L-5VXT-7QRP-3ZMN-8HWF", -- User key 13
    "S2XJ-8LQV-4TRP-7ZHD-6MKC", -- User key 14
    "SR6P-1KXT-9VQL-2HZN-5MFW", -- User key 15
    "S8QV-4ZKP-6XTR-1LHM-9JWD", -- User key 16
    "S3RX-9TYS-3GHD-7ZNM-G5JF", -- User key 17
    "S3LK-7VQX-1TRP-9ZHM-4NWD", -- User key 18
    "SN8Q-2XVL-5KRP-7ZMJ-1HDT", -- User key 19
    "S9ZT-6KQM-3XVR-8LPD-2JHG", -- User key 20
    "S4PX-8QVL-1KRT-6ZMN-5HJD", -- User key 21
    "SQ7L-3VXT-9KRP-2ZMH-8NWF", -- User key 22
    "S1XK-9LQV-4TRP-7ZHD-6MJB", -- User key 23
    "SM6P-2KXT-8VQL-5HZN-3RWF", -- User key 24
    "S8PD-3FES-6HDE-1JSA-0HUN", -- User key 25
    "ST2X-7QVL-3KRP-9ZMN-5HJF", -- User key 26
    "S5LK-9VQX-2TRP-8ZHM-4NWD", -- User key 27
    "SN3Q-6XVL-1KRP-7ZMJ-9HDT", -- User key 28
    "S9RT-4KQM-8XVL-2LPD-6JHG", -- User key 29
    "SX7P-5QVL-3KRT-1ZMN-8HJD", -- User key 30
    "S7KP-4ZXL-9QRT-2VMN-8HJD", -- User key 31
    "S3ZT-8LXM-1KPV-6QNR-4HWF", -- User key 32
    "S9LX-2QKP-7ZTR-5VMN-1HJD", -- User key 33
    "S5RV-1ZXL-8QKT-3PMN-7HFD", -- User key 34
    "S2KP-9LZT-4XRV-8QMN-6HJD", -- User key 35
    "S8ZX-3KLP-6QRT-1VMN-9HWF", -- User key 36
    "S4QL-7ZKP-2XRT-9VMN-5HJD", -- User key 37
    "S1ZT-6KXP-8QRL-4VMN-3HFD", -- User key 38
    "S6KP-2ZXL-5QRT-7VMN-8HJD", -- User key 39
    "S9ZX-4KLP-1QRT-6VMN-2HWF", -- User key 40
    "S3KP-8ZXL-7QRT-5VMN-1HJD", -- User key 41
    "S7ZT-2KXP-9QRL-4VMN-6HFD", -- User key 42
    "S5KP-1ZXL-8QRT-3VMN-9HJD", -- User key 43
    "S2ZX-6KLP-4QRT-7VMN-8HWF", -- User key 44
    "S8KP-3ZXL-1QRT-9VMN-5HJD", -- User key 45
    "S4ZT-7KXP-6QRL-2VMN-1HFD", -- User key 46
    "S1KP-9ZXL-5QRT-8VMN-3HJD", -- User key 47
    "S6ZX-2KLP-7QRT-4VMN-9HWF", -- User key 48
    "S9KP-5ZXL-3QRT-1VMN-8HJD", -- User key 49
    "S7ZX-4KLP-2QRT-6VMN-5HFD", -- User key 50
    "A4KD-7PQL-9XTR-2VMN-6HJF", -- User key 51
    "Z9LM-3QXT-5KRP-8VHN-1DWF", -- User key 52
    "R2PX-8LQT-6VMK-1ZHN-4JFD", -- User key 53
    "Y7TK-1QPL-8VXR-5MND-9HWF", -- User key 54
    "H3QV-9LXP-2KTR-7MND-6JWF", -- User key 55
    "K8LP-4QXT-7VNM-2RHD-5JWF", -- User key 56
    "V1QT-6KPL-9XRM-3HND-8JWF", -- User key 57
    "D5KP-2LQT-8VMR-1ZHN-7JWF", -- User key 58
    "J9LX-7QTP-4KRM-6VND-2HWF", -- User key 59
    "P3QT-8LKM-1XRV-9HND-5JWF", -- User key 60
    "F6KP-1LQT-7VMR-3ZHN-9JWD", -- User key 61
    "T2LX-9QKP-5VRM-8HND-4JWF", -- User key 62
    "W8QT-3LKM-6XRV-1HND-7JWF", -- User key 63
    "B4KP-7LQT-2VMR-9ZHN-5JWF", -- User key 64
    "N1LX-5QTP-8KRM-4VND-6HWF", -- User key 65
    "Q7RT-2LKM-9XVP-6HND-3JWF", -- User key 66
    "C9KP-4LQT-1VMR-7ZHN-8JWF", -- User key 67
    "U3LX-8QTP-6KRM-2VND-5HWF", -- User key 68
    "E5QT-1LKM-7XRV-9HND-4JWF", -- User key 69
    "M8KP-6LQT-3VMR-2ZHN-1JWF", -- User key 70
    "G2LX-7QTP-9KRM-5VND-8HWF", -- User key 71
    "L4QT-9KPM-2XRV-7HND-6JWF", -- User key 72
    "O7KP-3LQT-8VMR-4ZHN-5JWF", -- User key 73
    "I1LX-6QTP-4KRM-9VND-2HWF", -- User key 74
    "X8QT-5LKM-3VRP-1HND-7JWF", -- User key 75
    "Z2KP-9LQT-6VMR-8HND-4JWF", -- User key 76
    "R5LX-1QTP-7KRM-3VND-9HWF", -- User key 77
    "Y9QT-4LKM-8XRP-2HND-6JWF", -- User key 78
    "H6KP-2LQT-5VMR-1ZHN-7JWF", -- User key 79
    "K3LX-8QTP-9KRM-4VND-5HWF", -- User key 80
    "V7QT-1LKM-6XRP-9HND-2JWF", -- User key 81
    "D9KP-5LQT-3VMR-7ZHN-8JWF", -- User key 82
    "J4LX-2QTP-8KRM-6VND-1HWF", -- User key 83
    "P8QT-7LKM-1XRP-5HND-9JWF", -- User key 84
    "F3KP-6LQT-9VMR-2ZHN-4JWF", -- User key 85
    "T7LX-9QTP-4KRM-8VND-3HWF", -- User key 86
    "W2QT-8LKM-5XRP-1HND-6JWF", -- User key 87
    "B6KP-1LQT-7VMR-9ZHN-2JWF", -- User key 88
    "N9LX-4QTP-2KRM-7VND-5HWF", -- User key 89
    "Q3QT-6LKM-8XRP-4HND-1JWF", -- User key 90
    "C7KP-2LQT-5VMR-3ZHN-9JWF", -- User key 91
    "U1LX-9QTP-6KRM-8VND-4HWF", -- User key 92
    "E8QT-3LKM-7XRP-2HND-5JWF", -- User key 93
    "M2KP-4LQT-9VMR-6ZHN-7JWF", -- User key 94
    "G5LX-7QTP-1KRM-3VND-8HWF", -- User key 95
    "L9QT-2KPM-6XRV-5HND-4JWF", -- User key 96
    "O4KP-8LQT-3VMR-1ZHN-9JWF", -- User key 97
    "I7LX-5QTP-9KRM-2VND-6HWF", -- User key 98
    "X1QT-6LKM-4VRP-8HND-3JWF", -- User key 99
    "Z8KP-3LQT-7VMR-5HND-2JWF"  -- User key 100
}

local key = getgenv().Key

-- ตรวจว่ามีคีย์หรือไม่
if not key then
    player:Kick("Reaper Hub Wrong key")
    return
end

-- ฟังก์ชันเช็คคีย์
local function isValidKey(k)
    for _, v in ipairs(correctKeys) do
        if k == v then
            return true
        end
    end
    return false
end

if not isValidKey(key) then
    player:Kick("Invalid Key")
    return
end

print("Key verified! Loading main script...")
