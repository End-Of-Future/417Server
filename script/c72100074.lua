local m=72100074
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CUSTOM+m)
	e3:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.spcon)
    e3:SetTarget(cm.sptg)
    e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
    local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(m,1))
	e8:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetRange(LOCATION_MZONE)
    e8:SetCountLimit(1,m)
	e8:SetTarget(cm.tgtg)
	e8:SetOperation(cm.tgop)
	c:RegisterEffect(e8)
   	if not cm.global_check then
		cm.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_DESTROYED)
		ge2:SetCondition(cm.regcon)
		ge2:SetOperation(cm.regop)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.spcfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	local v=0
	if eg:IsExists(cm.spcfilter,1,nil,0) then v=v+1 end
	if eg:IsExists(cm.spcfilter,1,nil,1) then v=v+2 end
	if v==0 then return false end
	e:SetLabel(({0,1,PLAYER_ALL})[v])
	return true
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+m,re,r,rp,ep,e:GetLabel())
end 
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ev==tp or ev==PLAYER_ALL
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local atk=e:GetHandler():GetAttack()/2
	if chk==0 then return atk>0 end
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,2))
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and (c:GetAttack()/2)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(c:GetAttack()/2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then return c:IsAttackAbove(1500) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD)
end

function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 and c:IsRelateToEffect(e) and c:IsAttackAbove(1500) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1500)
		c:RegisterEffect(e1)
		if not c:IsHasEffect(EFFECT_REVERSE_UPDATE) then		
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	   	    local tc=g:Select(tp,1,1,nil)
	        Duel.HintSelection(tc)
	        Duel.SendtoGrave(tc,REASON_EFFECT)
        end
	end
end