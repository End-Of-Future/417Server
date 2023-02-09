--春巫 艾露迪
local m=10700072
local cm=_G["c"..m]

function cm.initial_effect(c)
    c:EnableCounterPermit(0x1)
	--link summon
	aux.AddLinkProcedure(c,nil,3,3,cm.lfcheck)
	c:EnableReviveLimit()
    --splimit
	local e0=Effect.CreateEffect(c)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(cm.regcon)
	e0:SetOperation(cm.regop)
	c:RegisterEffect(e0)
    --recover
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.regcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
    --release
    local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m+1)
	e1:SetCost(cm.recost)
	e1:SetTarget(cm.retg)
	e1:SetOperation(cm.reop)
	c:RegisterEffect(e1)
end

function cm.lfcheck(g)
	return g:IsExists(Card.IsRace,2,nil,RACE_SPELLCASTER)
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

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_REMOVED)
    local sg=Duel.GetMatchingGroup(Card.IsRace,tp,LOCATION_GRAVE,0,nil,RACE_SPELLCASTER)
	if chk==0 then return #g>0 or (#sg>0 and e:GetHandler():IsCanAddCounter(0x1,#sg)) end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,#g*300)
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetFieldGroup(tp,0,LOCATION_REMOVED)
    local sg=Duel.GetMatchingGroup(Card.IsRace,tp,LOCATION_GRAVE,0,nil,RACE_SPELLCASTER)
    local off=1
    local ops={}
    local opval={}
    if #g>0 then
        ops[off]=aux.Stringid(m,0)
        opval[off-1]=1
        off=off+1
    end
    if #sg>0 and c:IsRelateToEffect(e) and c:IsCanAddCounter(0x1,#sg) then
        ops[off]=aux.Stringid(m,1)
        opval[off-1]=2
        off=off+1
    end
    if off==1 then return end
    local op=Duel.SelectOption(tp,table.unpack(ops))
    if opval[op]==1 then
        Duel.Recover(tp,#g*300,REASON_EFFECT)
    elseif opval[op]==2 then
        c:AddCounter(0x1,#sg)
    end
end

function cm.costrfilter(c,lg)
    return lg:IsContains(c) and c:IsReleasable()
end

function cm.recost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local lg=c:GetLinkedGroup()
	if chk==0 then return lg:IsExists(Card.IsReleasable,1,nil) or c:IsCanRemoveCounter(tp,0x1,3,REASON_COST) end
	if lg:IsExists(Card.IsReleasable,1,nil) and ((not c:IsCanRemoveCounter(tp,0x1,3,REASON_COST)) or Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4))==0) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        local g=Duel.SelectMatchingCard(tp,cm.costrfilter,tp,0x04,0x04,1,1,nil,lg)
        if #g>0 then
            Duel.Release(g,REASON_COST)
        end
    else
        c:RemoveCounter(tp,0x1,3,REASON_COST)
    end
end

function cm.tgrfilter(c)
    return not c:IsAttack(0) and c:IsFaceup()
end

function cm.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(cm.tgrfilter,tp,0x04,0x04,nil)>0 or Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,0x0c,0,1,e:GetHandler(),0x1,3) end
end

function cm.reop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if Duel.GetMatchingGroupCount(cm.tgrfilter,tp,0x04,0x04,nil)>0 and ((not Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,0x0c,0,1,c,0x1,3)) or Duel.SelectOption(tp,aux.Stringid(m,5),aux.Stringid(m,6))==0) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
        local g=Duel.SelectMatchingCard(tp,cm.tgrfilter,tp,0x04,0x04,1,1,nil)
        local tc=g:GetFirst()
        if tc then
            Duel.HintSelection(g)
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetRange(LOCATION_MZONE)
            e1:SetValue(-500)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e1)
            local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetCode(EFFECT_CANNOT_ACTIVATE)
			e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e4:SetTargetRange(0,1)
            e4:SetLabelObject(tc)
			e4:SetValue(cm.aclimit)
			e4:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e4,tp)
            tc:RegisterFlagEffect(0,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
        end
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
        local g=Duel.SelectMatchingCard(tp,Card.IsCanAddCounter,tp,0x0c,0,1,1,c,0x1,3)
        local tc=g:GetFirst()
        if g then
            Duel.HintSelection(g)
            tc:AddCounter(0x1,3)
        end
    end
end

function cm.aclimit(e,re,tp)
	return re:GetHandler()==e:GetLabelObject() and re:IsActiveType(TYPE_MONSTER)
end