--GOD•无冕之王
local m = 88888277
local cm = _G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.linkfilter,1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(1,0)
	e0:SetTarget(cm.splimit)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetCondition(cm.con1)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.con2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.con3)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e4:SetCondition(cm.con4)
    e4:SetValue(cm.atlimit)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_UPDATE_ATTACK)
    e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
    e5:SetValue(-1000)
    e5:SetCondition(cm.con5)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(cm.con)
	e6:SetOperation(cm.op)
	c:RegisterEffect(e6)
end
function cm.linkfilter(c)
	return c:IsLevelAbove(8) and c:IsType(TYPE_EFFECT)
end
function cm.lvfilter0(c)
	return c:IsLevelBelow(12)
end
function cm.lvfilter1(c)
	return c:IsLevelBelow(11)
end
function cm.lvfilter2(c)
	return c:IsLevelBelow(10)
end
function cm.lvfilter3(c)
	return c:IsLevelBelow(9)
end
function cm.lvfilter4(c)
	return c:IsLevelBelow(8)
end
function cm.atlimit(e,c)
	return c~=e:GetHandler()
end
function cm.splimit(e,c)
	return c:IsLevelBelow(4)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.lvfilter0,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.lvfilter1,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.lvfilter2,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.lvfilter3,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.con5(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.lvfilter4,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and tc:IsCode((m))
end 
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    if Duel.SelectOption(tp,aux.Stringid(m,0)) and Duel.SelectOption(1-tp,aux.Stringid(m,0)) then
        if Duel.SelectOption(tp,aux.Stringid(m,1)) and Duel.SelectOption(1-tp,aux.Stringid(m,1)) then
            if Duel.SelectOption(tp,aux.Stringid(m,2)) and Duel.SelectOption(1-tp,aux.Stringid(m,2)) then
                if Duel.SelectOption(tp,aux.Stringid(m,3)) and Duel.SelectOption(1-tp,aux.Stringid(m,3)) then
                    if Duel.SelectOption(tp,aux.Stringid(m,4)) and Duel.SelectOption(1-tp,aux.Stringid(m,4)) then
                        Duel.SelectOption(tp,aux.Stringid(m,5))
                        Duel.SelectOption(1-tp,aux.Stringid(m,5))
                    end
                end
            end
        end
    end
end