--战华老宝·谋黄忠
local m=10703009
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
    e2:SetTarget(cm.aatg)
    e2:SetOperation(cm.atkop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_CHAINING)
    e3:SetRange(LOCATION_MZONE)
    e3:SetOperation(cm.ckop)
    c:RegisterEffect(e3)
end

function cm.eibcon(e)
    return e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end

function cm.costcfilter(c)
    return c:islocation(LOCATION_REMOVED) and c:IsPosition(POS_FACEDOWN)
end

function cm.aacost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local contck=c:GetFlagEffect(107030090)~=0
    local monsck=c:GetFlagEffect(m)~=0
    local spelck=c:GetFlagEffect(m+1)~=0
    local trapck=c:GetFlagEffect(m+2)~=0
    local ck=0
    if contck then ck=ck+1 end
    if monsck then ck=ck+1 end
    if spelck then ck=ck+1 end
    if trapck then ck=ck+1 end
    local g=Duel.GetDecktopGroup(tp,ck-1)
    if chk==0 then return ck>=2 and #g>0 and g:IsExists(Card.IsAbleToGraveAsCost,#g,nil) end
    local p=0
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_COST)
        local tc=g:GetFirst()
        while tc do
            if tc:IsType(TYPE_CONTINUOUS) or tc:IsType(TYPE_FIELD) or tc:IsType(TYPE_PENDULUM) or tc:IsType(TYPE_EQUIP) then
                if contck then p=p+1 end
            elseif ((tc:IsType(TYPE_MONSTER) and monsck) or (tc:IsType(TYPE_SPELL) and spelck) or (tc:IsType(TYPE_TRAP) and trapck)) then
                p=p+1
            end
            tc=g:GetNext()
        end
    end
    e:SetLabel(2000*p)
end

function cm.aatg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return true end
    c:ResetFlagEffect(107030090)
    c:ResetFlagEffect(m)
    c:ResetFlagEffect(m+1)
    c:ResetFlagEffect(m+2)
    Duel.SetChainLimit(cm.chainlm)
end

function cm.chainlm(re,rp,tp)
	return tp==rp or re:GetHandler():IsLocation(LOCATION_HAND)
end

function cm.opcfilter(c)
    return c:IsDiscardable() and c:IsType(TYPE_SPELL)
end

function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
        local a=0
        if Duel.IsExistingMatchingCard(cm.opcfilter,tp,0x02,0,1,nil) and Duel.GetFlagEffect(tp,m)==0 and Duel.SelectYesNo(tp,aux.Stringid(10703000,1)) and Duel.DiscardHand(tp,cm.opcfilter,1,1,REASON_COST,nil) then
            a=a+1
            Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,0,1)
        end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE)
		e1:SetValue(e:GetLabel()+(a*2000))
		c:RegisterEffect(e1)
	end
end

function cm.ckop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=re:GetHandler()
    if rc:IsCode(m) then return false end
    if (rc:IsType(TYPE_CONTINUOUS) or rc:IsType(TYPE_FIELD) or rc:IsType(TYPE_PENDULUM) or rc:IsType(TYPE_EQUIP)) then
        if c:GetFlagEffect(107030090)==0 then
            c:RegisterFlagEffect(107030090,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
        end
    elseif rc:IsType(TYPE_MONSTER) and c:GetFlagEffect(m)==0 then
        c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
    elseif rc:IsType(TYPE_SPELL) and c:GetFlagEffect(m+1)==0 then
        c:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
    elseif rc:IsType(TYPE_TRAP) and c:GetFlagEffect(m+2)==0 then
        c:RegisterFlagEffect(m+2,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
    end
end
