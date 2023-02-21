--邪种蚀暗兽 三首血月龙
--script by -k/3
local m=88881702
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.sprcon)
	e2:SetOperation(cm.sprop)
	c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_EQUIP)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,m)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetTarget(cm.etg)
    e3:SetOperation(cm.eop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_SET_CONTROL)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e4:SetTarget(cm.cttg)
    e4:SetValue(cm.ctv)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetTarget(cm.dtg)
	e5:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e5)
    local e6=e5:Clone()
    e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e6:SetTarget(cm.cttg)
    e6:SetValue(1)
    c:RegisterEffect(e6)
    local e7=e6:Clone()
    e7:SetCode(EFFECT_UPDATE_ATTACK)
    e7:SetValue(cm.atkval)
    c:RegisterEffect(e7)
    local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetTarget(cm.indtg)
	e8:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e8:SetValue(1)
	c:RegisterEffect(e8)
    local e9=e8:Clone()
    e9:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e9)
end
function cm.sprfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(9) and c:IsAbleToGraveAsCost()
end
function cm.sprfilter1(c,tp,g,sc)
	local lv=c:GetLevel()
	return c:IsType(TYPE_TUNER) and g:IsExists(cm.sprfilter2,1,c,tp,c,sc,lv)
end
function cm.sprfilter2(c,tp,mc,sc,lv)
	local sg=Group.FromCards(c,mc)
	return c:IsLevel(lv) and not c:IsType(TYPE_TUNER)
		and Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.sprfilter,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(cm.sprfilter1,1,nil,tp,g,c)
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cm.sprfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:FilterSelect(tp,cm.sprfilter1,1,1,nil,tp,g,c)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=g:FilterSelect(tp,cm.sprfilter2,1,1,mc,tp,mc,c,mc:GetLevel())
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end
function cm.efilter(c)
    return c:IsSetCard(0x891) and not c:IsForbidden() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function cm.etg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.efilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.efilter,tp,LOCATION_GRAVE,0,1,nil)
        and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,cm.efilter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function cm.eop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e)
    and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
    and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
        local sc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
        if sc then
            Duel.Equip(tp,tc,sc)
            local e1=Effect.CreateEffect(e:GetHandler())
		    e1:SetType(EFFECT_TYPE_SINGLE)
		    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		    e1:SetCode(EFFECT_EQUIP_LIMIT)
		    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		    e1:SetLabelObject(sc)
		    e1:SetValue(cm.eqlimit)
		    tc:RegisterEffect(e1)
        end
    end
end
function cm.eqlimit(e,c)
    return e:GetLabelObject()==c
end
function cm.cttg(e,c)
    return c:GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0x891)
end
function cm.ctv(e,c)
    return e:GetHandlerPlayer()
end
function cm.dtg(e,c)
    return (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0) and not c:GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0x891)
end
function cm.atkval(e,c)
    local v=0
    for tc in aux.Next(c:GetEquipGroup()) do
        v=v+tc:GetAttack()
    end
    return v
end
function cm.indtg(e,c)
    return c:IsSetCard(0x891) and c:IsFaceup()
end
