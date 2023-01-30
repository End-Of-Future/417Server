--春巫 摩卡莫莉
local m=10700075
local cm=_G["c"..m]

function cm.initial_effect(c)
	c:EnableCounterPermit(0x1)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),2,3,cm.lfcheck)
	c:EnableReviveLimit()
    --splimit
	local e0=Effect.CreateEffect(c)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(cm.regcon)
	e0:SetOperation(cm.regop)
	c:RegisterEffect(e0)
    --attackup
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(cm.atkval)
    c:RegisterEffect(e1)
    --release
    local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.recost)
	e2:SetTarget(cm.retg)
	e2:SetOperation(cm.reop)
	c:RegisterEffect(e2)
    --count
    local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,m+1)
	e3:SetCondition(cm.descon)
	e3:SetCost(cm.descost)
	e3:SetTarget(cm.destg)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)
end

function cm.lfcheck(g)
	return g:IsExists(Card.IsType,1,nil,TYPE_LINK)
end

function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end

function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
end

function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(m) and bit.band(sumtype,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end

function cm.atkval(e)
    local tp=e:GetHandlerPlayer()
    return Duel.GetCounter(tp,0x0c,0,0x1)*200
end

function cm.costrfilter(c,lg)
    return lg:IsContains(c) and c:IsReleasable()
end

function cm.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,0x0c,0,0x1,5,REASON_COST) end
	Duel.RemoveCounter(tp,0x0c,0,0x1,5,REASON_COST)
end

function cm.tgrfilter(c)
    return c:IsType(TYPE_SPELL) and c:IsAbleToDeck()
end

function cm.retg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(cm.tgrfilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return #g>0 end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,nil,nil)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function cm.reop(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetMatchingGroup(cm.tgrfilter,tp,LOCATION_GRAVE,0,nil)
    if #tg==0 then return false end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,cm.tgrfilter,tp,LOCATION_GRAVE,0,1,#tg,nil)
    if #g>0 then
        Duel.HintSelection(g)
        if Duel.SendtoDeck(g,nil,2,REASON_EFFECT) and g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)==5 then
            Duel.BreakEffect()
            if Duel.Draw(tp,1,REASON_EFFECT) then
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_FIELD)
                e1:SetCode(EFFECT_CANNOT_TO_HAND)
                e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
                e1:SetTargetRange(1,0)
                e1:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK))
                e1:SetReset(RESET_PHASE+PHASE_END)
                Duel.RegisterEffect(e1,tp)
                local e2=Effect.CreateEffect(e:GetHandler())
                e2:SetType(EFFECT_TYPE_FIELD)
                e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
                e2:SetCode(EFFECT_CANNOT_DRAW)
                e2:SetReset(RESET_PHASE+PHASE_END)
                e2:SetTargetRange(1,0)
                Duel.RegisterEffect(e2,tp)
            end
        end
    end
end

function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsCode(m)
end

function cm.costdfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost() and (c:IsFaceup() or c:IsLocation(0x0a))
end

function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.costdfilter,tp,0x0a,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.costdfilter,tp,0x0a,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_COST)
	end
end

function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanAddCounter(0x1,3) end
end

function cm.desop(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsCanAddCounter(0x1,3) then
        c:AddCounter(0x1,3)
    end
end