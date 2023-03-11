--方界星 寻引之蓝神
local m=88888888
local cm=_G["c"..m]

function cm.initial_effect(c)
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(cm.lmfilter),1,1)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,m)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
    --SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,m+1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(cm.spcost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
    --atk
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetTarget(cm.atktg)
	e3:SetOperation(cm.atkop)
	c:RegisterEffect(e3)
end

function cm.lmfilter(c)
	return c:IsSetCard(0xe3) and not c:IsLevel(10)
end

function cm.filter(c,code)
	return c:IsSetCard(0xe3) and c:IsAbleToHand() and c:IsType(TYPE_SPELL) and c:GetCode()~=code
end

function cm.cfilter(c,tp)
	return c:IsSetCard(0xe3) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,c:GetCode())
end

function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_DECK,0,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
    e:SetLabel(g:GetFirst():GetCode())
	Duel.SendtoGrave(g,REASON_COST)
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local code=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,code)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function cm.spcfilter(c,e,tp,zone)
	return not c:IsPublic() and c:IsSetCard(0xe3) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEUP,tp,zone)
end

function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spcfilter,tp,LOCATION_HAND,0,1,nil,e,tp,c:GetLinkedZone()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spcfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,c:GetLinkedZone())
    local tc=g:GetFirst()
    if tc then
        Duel.ConfirmCards(1-tp,tc)
        e:SetLabelObject(tc)
    end
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
    local tc=e:GetLabelObject()
    Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,nil,nil)
    if tc:IsCode(30270176) then
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
    end
end

function cm.spofilter(c,e,tp)
    return c:IsCode(72664875) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    local c=e:GetHandler()
    if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP,c:GetLinkedZone()) then
        if tc:IsCode(30270176) and not Duel.IsPlayerAffectedByEffect(tp,59822133) and tc:IsReleasableByEffect() and Duel.IsExistingMatchingCard(cm.spofilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
            Duel.BreakEffect()
            local g=Duel.SelectMatchingCard(tp,cm.spofilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
            if g:GetCount()>0 then
                Duel.Release(tc,REASON_COST)
                Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
            end
        end
    end
end

function cm.atkrop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    c:ResetFlagEffect(m)
    if Duel.GetAttackTarget()~=nil and Duel.GetAttackTarget():GetControler()==1-tp then
	    e:SetLabelObject(Duel.GetAttackTarget())
    else
        c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
    end
end

function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if chk==0 then return bc and bc:IsFaceup() and bc:IsRelateToBattle() and bc:IsCanAddCounter(0x1038,1)
		and c:IsLocation(LOCATION_MZONE) and c:IsRelateToBattle()
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
    Duel.SetTargetCard(bc)
end

function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:GetSequence()>4 and Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_ADD_TYPE)
        e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        c:RegisterEffect(e1,true)
        if tc:IsRelateToEffect(e) then
            Duel.BreakEffect()
            tc:AddCounter(0x1038,1)
        end
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_FIELD)
        e3:SetCode(EFFECT_DISABLE)
        e3:SetRange(LOCATION_SZONE)
        e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD)
        e3:SetTarget(cm.actg)
        c:RegisterEffect(e3,true)
        local e4=e3:Clone()
        e4:SetCode(EFFECT_CANNOT_ATTACK)
        c:RegisterEffect(e4,true)
    end
end

function cm.actg(e,c)
	return c:IsFaceup() and c:GetCounter(0x1038)>0
end