--战华之宝·界徐盛
local m=10703000
local cm=_G["c"..m]

function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(cm.eibcon)
	c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_HANDES)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_ATTACK_ANNOUNCE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(cm.aacost)
    e2:SetOperation(cm.atkop)
    c:RegisterEffect(e2)
end

function cm.eibcon(e)
    return e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end

function cm.costcfilter(c)
    return c:IsLocation(LOCATION_REMOVED) and c:IsPosition(POS_FACEDOWN)
end

function cm.aacost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetMatchingGroupCount(Card.IsAbleToRemoveAsCost,tp,0,0x0a,Duel.GetAttackTarget(),POS_FACEDOWN)>0 and Duel.GetLP(1-tp)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local num=Duel.GetLP(1-tp)
    if num%2000>0 then
        num=(num//2000)+1
    else
        num=num//2000
    end
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,0,0x0e,1,num,Duel.GetAttackTarget(),POS_FACEDOWN)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.Remove(g,POS_FACEDOWN,REASON_COST)
    end
    local g1=g:Filter(cm.costcfilter,nil)
    if g1:GetCount()>0 then
        g1:KeepAlive()
        local tc=g1:GetFirst()
        while tc do
            tc:RegisterFlagEffect(m,RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,0,1)
            tc=g1:GetNext()
        end
        local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetReset(RESET_PHASE+PHASE_END)
        e1:SetCountLimit(1)
        e1:SetLabelObject(g1)
		e1:SetOperation(cm.thop)
		Duel.RegisterEffect(e1,tp)
    end
end

function cm.optfilter(c)
    return c:GetFlagEffect(m)~=0
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local g=e:GetLabelObject():Filter(cm.optfilter,nil)
    Duel.SendtoHand(g,1-tp,REASON_EFFECT)
end

function cm.opcfilter(c)
    return c:IsDiscardable() and c:IsType(TYPE_SPELL)
end

function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
        local a=0
        if Duel.GetFieldGroupCount(tp,0x0c,0)>=Duel.GetFieldGroupCount(tp,0,0x0c) and Duel.GetFieldGroupCount(tp,0x02,0)>=Duel.GetFieldGroupCount(tp,0,0x02) then
            a=a+1
        end
        if c:GetEquipCount()>0 and Duel.GetFieldGroupCount(tp,0,0x01)==0 then
            a=a+1
        end
        if Duel.IsExistingMatchingCard(cm.opcfilter,tp,0x02,0,1,nil) and Duel.GetFlagEffect(tp,m)==0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) and Duel.DiscardHand(tp,cm.opcfilter,1,1,REASON_COST,nil) then
            a=a+1
            Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,0,1)
        end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE)
		e1:SetValue(2000*a)
		c:RegisterEffect(e1)
	end
end